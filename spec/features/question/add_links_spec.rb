require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Details', with: 'text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds link when asks question with errors' do

  end
end