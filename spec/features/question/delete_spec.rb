require 'rails_helper'

feature 'Author can delete his question', "
  In order to delete question
  As an authenticated user and question author
  I'd like to be able to delete my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'tries to delete his question' do
      login(question.user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      click_on 'Delete question'

      expect(page).to have_content 'Your question was successfully deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'tries to delete question that is not his' do
      login(user)
      visit question_path(question)
      expect(page).not_to have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete question'
  end

  describe 'multiple sessions', js: true do
    scenario "question disappears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Delete question'

        expect(page).to have_content 'Your question was successfully deleted.'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end
    end
  end
end
