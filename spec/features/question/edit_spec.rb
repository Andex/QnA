require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As un author of question
  I'd like to be able to edit my question
" do
  given!(:question) { create(:question) }
  given!(:question_with_files) { create(:question, :with_files) }
  given!(:question_with_links) { create(:question, :with_links) }
  given!(:question_with_reward) { create(:question, :with_reward) }
  given!(:user) { create(:user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
    expect(page).to_not have_link 'Delete file'
    expect(page).to_not have_link 'Delete link'
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

  describe 'Authenticated author while editing his question with added links', js: true do
    background do
      login(question_with_links.user)
      visit question_path(question_with_links)

      click_on 'Edit question'
    end

    scenario 'tries to add links' do
      within '.question' do
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

      within '.question' do
        expect(page).to_not have_link link.name
      end
      expect(page).to have_content 'Your link was deleted.'
    end
  end

  describe 'Authenticated author while editing his question with assigned reward', js: true do
    scenario 'tries to delete assigned reward' do
      login(question_with_reward.user)
      visit question_path(question_with_reward)

      click_on 'Edit question'

      accept_confirm do
        click_link 'Delete the reward'
      end

      question_with_reward.reload

      within '.question' do
        expect(page).to_not have_css '.reward'
        expect(question_with_reward.reward).to eq nil
      end
      expect(page).to have_content 'Question reward was removed.'
    end
  end

  describe 'multiple sessions', js: true do
    scenario "question changes on another user's page" do
      Capybara.using_session('user') do
        login(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
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

      Capybara.using_session('guest') do
        expect(page).to have_content 'edited question'
        expect(page).to have_content 'edited details'
      end
    end
  end
end
