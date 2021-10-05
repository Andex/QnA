require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As un author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer_with_files) { create(:answer, :with_files, question: question) }
  given!(:answer_with_links) { create(:answer, :with_links, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_link 'Delete answer'
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated author', js: true do
    background do
      login(answer.user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your new answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to attach files while editing his answer' do
      click_on 'Edit'

      within '.answers' do
        attach_file 'Attach files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end

    scenario 'tries to add links while editing his answer' do
      click_on 'Edit'

      within '.answers' do
        click_on 'Add link'

        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url

        click_on 'Save'

        expect(page).to have_link link.name
        expect(page).to_not have_selector 'text_field'
      end
    end

    scenario 'opens and cancels the edit form for his answer' do
      click_on 'Edit'

      click_on 'Cancel'

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your new answer', with: ''

        click_on 'Add link'
        fill_in 'Link name', with: link.name
        fill_in 'Url', with: ''

        click_on 'Save'
      end
      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Links url can't be blank"
        expect(page).to have_content "Links url is not a valid URL"
      end
    end
  end

  describe 'Authenticated author while editing his answer with attach files', js: true do
    background do
      login(answer_with_files.user)
      visit question_path(answer_with_files.question)
    end

    scenario 'tries to add files' do
      click_on 'Edit'

      within '.answers' do
        attach_file 'Attach files', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end

    scenario 'tries to delete attached files' do
      click_on 'Edit'

      accept_confirm do
        click_link 'Delete file'
      end

      within '.answers' do
        expect(page).to_not have_content answer_with_files.files.first.filename.to_s
      end
      expect(page).to have_content 'Your file was deleted.'
    end
  end

  describe 'Authenticated author while editing his answer with added links', js: true do
    background do
      login(answer_with_links.user)
      visit question_path(answer_with_links.question)

      click_on 'Edit'
    end

    scenario 'tries to add links' do
      within '.answers' do
        click_on 'Add link'

        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url

        click_on 'Save'

        expect(page).to have_link link.name
        expect(page).to_not have_selector 'text_field'
      end
    end

    scenario 'tries to delete added links' do
      accept_confirm do
        click_link 'Delete link'
      end
      # save_and_open_page
      within ".answer-id-#{answer_with_links.id}" do
        expect(page).to_not have_link link.name
      end
      expect(page).to have_content 'Your link was deleted.'
    end
  end

  describe 'multiple sessions', js: true do
    scenario "answer changes on another user's page" do
      Capybara.using_session('user') do
        login(answer.user)
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        click_on 'Edit'

        within '.answers' do
          fill_in 'Your new answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
