require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As un author of question
  I'd like to be able to edit my question
" do
  given!(:question) { create(:question) }
  given!(:question_with_files) { create(:question, :with_files) }
  given!(:user) { create(:user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Authenticated user tries to edit other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
    expect(page).to_not have_link 'Delete file'
  end

  describe 'Authenticated author', js: true do
    background do
      login(question.user)
      visit question_path(question)
    end

    scenario 'tries to edit his question' do
      click_on 'Edit question'
      fill_in 'Your question', with: 'edited question'
      fill_in 'Details', with: 'edited details'
      click_on 'Save'

      expect(page).to have_content 'edited question'
      expect(page).to have_content 'edited details'

      within '.edit-question-form' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to attach files while editing his question' do
      click_on 'Edit question'
      attach_file 'Attach files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'Save'

      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end

    scenario 'tries to add links while editing his question' do
      click_on 'Edit question'

      within '.question' do
        click_on 'Add link'

        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url

        click_on 'Save'

        expect(page).to have_link link.name
        expect(page).to_not have_selector 'text_field'
      end
    end

    scenario 'opens and cancels the edit form for his question' do
      click_on 'Edit question'

      click_on 'Cancel'

      within '.question' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his question with errors' do
      click_on 'Edit question'
      fill_in 'Your question', with: ''
      fill_in 'Details', with: ''

      within '.question' do
        click_on 'Add link'
        fill_in 'Link name', with: link.name
        fill_in 'Url', with: ''

        click_on 'Save'
      end

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Links url can't be blank"
        expect(page).to have_content "Links url is not a valid URL"
      end
    end
  end

  describe 'Authenticated author while editing his question with attach files', js: true do
    background do
      login(question_with_files.user)
      visit question_path(question_with_files)
    end

    scenario 'tries to add files' do
      click_on 'Edit question'
      attach_file 'Attach files', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Save'

      within '.question' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end

    scenario 'tries to delete attached files' do
      click_on 'Edit question'

      accept_confirm do
        click_link 'Delete file'
      end

      within '.question' do
        expect(page).to_not have_content question_with_files.files.first.filename.to_s
      end
      expect(page).to have_content 'Your file was deleted.'
    end
  end
end
