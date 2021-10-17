require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }
  given(:invalid_url) { 'gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }

  background do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Details', with: 'text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end

  scenario 'User adds invalid link when asks question', js: true do
    fill_in 'Url', with: invalid_url

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
    expect(page).to_not have_link 'My gist', href: invalid_url
  end
end
