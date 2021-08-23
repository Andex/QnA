require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As un author of answer
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer' do
      login(user)
      visit question_path(question)
      # save_and_open_page
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your new answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors'
    scenario "tries to edit other user's question"

  end
end
