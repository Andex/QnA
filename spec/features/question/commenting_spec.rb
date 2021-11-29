require 'rails_helper'

feature 'User can comment on the question', "
  In order to comment a question
  As un authenticated user
  I'd like to be able to write comments on a question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, commentable: question) }

  describe 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario "can't to comment to the question" do
      expect(page).to_not have_link 'Add comment to the question'
    end

    scenario "can't to remove the comment on the question" do
      expect(page).to_not have_link 'Delete'
    end
  end

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

    scenario "can't to remove someone else's comment on the question" do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated author', js: true do
    scenario 'removes the comment on the question' do
      login(comment.user)
      visit question_path(question)

      accept_confirm do
        click_on 'Delete'
      end

      within '.question' do
        expect(page).to_not have_content comment.body
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

    scenario "the comment to the question is deleted on another user's page" do
      Capybara.using_session('user') do
        login(comment.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Delete'

        within '.question' do
          expect(page).to_not have_content comment.body
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to_not have_content comment.body
        end
      end
    end
  end
end
