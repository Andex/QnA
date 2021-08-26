require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As un author of answer
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated author', js: true do
    background do
      login(answer.user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
     click_on 'Edit'

      within '.answers' do
        fill_in 'Your new answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your new answer', with: ''
        click_on 'Save'
      end
      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
