require 'rails_helper'

feature 'User can comment on the question', "
  In order to comment a question
  As un authenticated user
  I'd like to be able to write comments on a question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Unauthenticated user' do
    scenario "can't to comment to the question" do
      visit question_path(question)

      expect(page).to_not have_link 'Add comment to the question'
    end
  end

  # describe 'Authenticated author' do
  #   scenario 'tries to comment to the question' do
  #     login(question.user)
  #     visit question_path(question)
  #
  #     expect(page).to_not have_link 'Add comment to the question'
  #   end
  # end

  describe 'Authenticated user', js: true do
    before do
      login(user)
      visit question_path(question)
    end

    scenario 'comments on the question' do
      click_on 'Add comment to the question'

      fill_in 'Your comment', with: 'Comment text'
      click_on 'To publish'

      within '.question' do
        expect(page).to have_content 'Comment text'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'multiple sessions', js: true do
    scenario "comment to the question appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment to the question'

        fill_in 'Your comment', with: 'Comment text'
        click_on 'To publish'

        within '.question' do
          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
