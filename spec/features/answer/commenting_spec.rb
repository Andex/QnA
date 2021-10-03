require 'rails_helper'

feature 'User can comment on the answer on question', "
  In order to comment an answer
  As un authenticated user
  I'd like to be able to write comments on an answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Unauthenticated user' do
    scenario "can't to comment to the answer" do
      visit question_path(question)

      expect(page).to_not have_link 'Add comment to the answer'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to comment to the question' do
      login(answer.user)
      visit question_path(question)

      expect(page).to_not have_link 'Add comment to the answer'
    end
  end

  describe 'Authenticated user', js: true do
    before do
      login(user)
      visit question_path(question)
    end

    scenario 'comments on the question' do
      click_on 'Add comment to the answer'

      fill_in 'Your comment', with: 'Comment text'
      click_on 'To publish'

      within '.answers' do
        expect(page).to have_content 'Comment text'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'multiple sessions', js: true do
    scenario "comment to the answer appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment to the answer'

        fill_in 'Your comment', with: 'Comment text'
        click_on 'To publish'

        within '.answers' do
          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
