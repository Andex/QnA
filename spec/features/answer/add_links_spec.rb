require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }
  given(:invalid_url) { 'gist.github.com/Andex/adaaec3cd7d9e72b9e4d3a89465aeb34' }

  before do
    login(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when asks answer', js: true do
    fill_in 'Url', with: gist_url

    click_on 'To answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  scenario 'User adds invalid link when asks answer', js: true do
    fill_in 'Url', with: invalid_url

    click_on 'To answer'

    expect(page).to have_content 'Links url is not a valid URL'
    expect(page).to_not have_link 'My gist', href: invalid_url
  end
end
