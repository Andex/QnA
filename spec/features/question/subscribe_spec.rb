require 'rails_helper'

feature 'User can subscribe to updates on the question', "
  In order to subscribe the question
  As an authenticated user
  I'd like to be able to subscribe to the question
" do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    background do
      login(user)
      visit question_path(question)
    end

    scenario 'User subscribes to updates on the question' do
      click_on 'Subscribe to updates'

      expect(page).to have_link 'Unsubscribe to updates'
      expect(page).to_not have_link 'Subscribe to updates'
    end

    context 'When user already subscribe' do
      given!(:subscription) { question.subscriptions.create(user: user) }

      scenario 'User unsubscribes to updates on the question' do
        visit question_path(question)

        click_on 'Unsubscribe to updates'

        expect(page).to have_link 'Subscribe to updates'
        expect(page).to_not have_link 'Unsubscribe to updates'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    given(:question) { create(:question) }

    scenario 'User assigns reward when asks question' do
      visit question_path(question)

      expect(page).to_not have_css '.subscription'
      expect(page).to_not have_link 'Subscribe to updates'
      expect(page).to_not have_link 'Unsubscribe to updates'
    end
  end
end
