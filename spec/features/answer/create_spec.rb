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

      # expect(page).to have_content 'Your answer successfully created.'
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
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
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
