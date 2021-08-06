require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As un authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Title question'
      fill_in 'Body', with: 'Text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Title question'
      expect(page).to have_content 'Text text text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
