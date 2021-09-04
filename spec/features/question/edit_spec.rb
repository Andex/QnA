require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As un author of question
  I'd like to be able to edit my question
" do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    background do
      login(question.user)
      visit question_path(question)
    end

    scenario 'tries edit his question' do
      click_on 'Edit question'
      fill_in 'Your question', with: 'edited question'
      fill_in 'Details', with: 'edited details'
      click_on 'Save'

      expect(page).to have_content 'edited question'
      expect(page).to have_content 'edited details'
      # save_and_open_page
      within '.edit-question-form' do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries edit his question with errors' do
      click_on 'Edit question'
      fill_in 'Your question', with: ''
      fill_in 'Details', with: ''
      click_on 'Save'

      within '.question-errors' do
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "tries to edit other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
