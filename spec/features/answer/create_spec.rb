require 'rails_helper'

feature 'User can answer the question', "
  In order to answer the question
  As un authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Your answer', with: 'Answer the question'
      click_on 'To answer'

      within '.answers' do
        expect(page).to have_content 'Answer the question'
      end
    end

    scenario 'answer the question with errors' do
      click_on 'To answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer the question with attached files' do
      fill_in 'Your answer', with: 'Answer the question'
      attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'To answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'does not see a message about the need to sign in' do
      expect(page).to_not have_content 'If you want to leave your answer you must log in'
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'does not see the form of new answer' do
      expect(page).to_not have_content 'To answer'
    end

    scenario 'sees a message with a link to authorization' do
      expect(page).to have_content 'If you want to leave your answer you must log in'

      click_on 'log in'

      expect(page).to have_content 'Email'
      expect(page).to have_content 'Password'
      expect(page).to have_content 'Log in'
    end
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Answer the question'
        click_on 'To answer'

        within '.answers' do
          expect(page).to have_content 'Answer the question'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer the question'
        end
      end
    end
  end
end
