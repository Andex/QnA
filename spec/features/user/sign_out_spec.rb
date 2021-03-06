require 'rails_helper'

feature 'User can sign out', "
  In order to end session
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
