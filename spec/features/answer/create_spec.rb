require 'rails_helper'

feature 'User can answer the question', %q{
  In order to answer the question
  As un authenticated user
  I'd like to be able to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Body', with: 'Answer the question'
      click_on 'To answer'

      expect(page).to have_content 'Your answer successfully created.'
    end

    scenario 'answer the question with errors' do
      click_on 'To answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end