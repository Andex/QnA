require 'rails_helper'

feature 'User can register', "
  In order to ask questions
  As an registered user
  I'd like to be able to register
" do
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to register' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '121212'
    fill_in 'Password confirmation', with: '121212'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to register with invalid data' do
    fill_in 'Email', with: 'user'
    fill_in 'Password', with: '121212'
    fill_in 'Password confirmation', with: '121212'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'Unregistered user enters password less than 6 characters' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12'
    fill_in 'Password confirmation', with: '12'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'An unregistered user enters a password confirmation that does not match the password' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '121212'
    fill_in 'Password confirmation', with: '12'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Unregistered user leaves the email blank' do
    fill_in 'Password', with: '121212'
    fill_in 'Password confirmation', with: '121212'
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Unregistered user leaves the password blank' do
    fill_in 'Email', with: 'user@test.com'
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Unregistered user enters an existing email' do
    User.create!(email: 'user@test.com', password: 'qwerty')

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '121212'
    fill_in 'Password confirmation', with: '121212'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  describe 'Register with Omniauth services' do
    describe 'Github' do
      it 'user sign in with correct data' do
        visit new_user_registration_path
        expect(page).to have_content('Sign in with GitHub')

        mock_auth_hash('github', email: 'user@test.com')
        click_link 'Sign in with GitHub'

        expect(page).to have_content('Ask question')
        expect(page).to have_button('Log out')
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      it 'can handle authentication error' do
        invalid_mock('github')
        visit new_user_registration_path
        expect(page).to have_content('Sign in with GitHub')

        click_link 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end
  end
end
