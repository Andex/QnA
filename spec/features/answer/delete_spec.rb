require 'rails_helper'

feature 'Author can delete his answer', "
  In order to delete an answer to a question
  As an authenticated user and answer author
  I'd like to be able to delete my answer
" do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    scenario 'tries to delete his answer' do
      login(answer.user)
      visit question_path(answer.question)

      expect(page).to have_content answer.body

      accept_confirm do
        click_link 'Delete answer'
      end

      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete answer that is not his' do
      login(user)
      visit question_path(answer.question)
      expect(page).not_to have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete answer'
  end

  describe 'multiple sessions', js: true do
    scenario "answer disappears on another user's page" do
      Capybara.using_session('user') do
        login(answer.user)
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        expect(page).to have_content answer.body

        accept_confirm do
          click_link 'Delete answer'
        end

        expect(page).to_not have_content answer.body
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_content answer.body
      end
    end
  end
end
