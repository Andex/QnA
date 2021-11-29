require 'rails_helper'

feature 'User can comment on the answer on question', "
  In order to comment an answer
  As un authenticated user
  I'd like to be able to write comments on an answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }

  describe 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario "can't to comment to the answer" do
      expect(page).to_not have_link 'Add comment to the answer'
    end

    scenario "can't to remove the comment on an answer" do
      expect(page).to_not have_link 'Delete'
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

    scenario "can't to remove someone else's comment on an answer" do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated author', js: true do
    scenario 'removes the comment on the answer' do
      login(comment.user)
      visit question_path(question)

      accept_confirm do
        click_on 'Delete'
      end

      within '.answers' do
        expect(page).to_not have_content comment.body
      end
    end
  end

  describe 'multiple sessions', js: true do
    scenario "comment to the answer appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
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

    scenario "the comment to the answer is deleted on another user's page" do
      Capybara.using_session('user') do
        login(comment.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Delete'

        within '.answers' do
          expect(page).to_not have_content comment.body
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to_not have_content comment.body
        end
      end
    end
  end
end
