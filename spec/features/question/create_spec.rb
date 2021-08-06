require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As un authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user asks a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Ask question'
    fill_in 'Title', with: 'Title question'
    fill_in 'Body', with: 'Text text text'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Title question'
    expect(page).to have_content 'Text text text'
  end
end