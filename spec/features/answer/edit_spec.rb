require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As un author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer_with_files) { create(:answer, :with_files, question: question) }

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

    scenario 'tries to attach files while editing his answer' do
      click_on 'Edit'

      within '.answers' do
        attach_file 'Attach files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end

    scenario 'open and cancel edit his answer' do
      click_on 'Edit'

      click_on 'Cancel'

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
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

  describe 'Authenticated user while editing his answer with attach files', js: true do
    scenario 'tries to add files' do
      login(answer_with_files.user)
      visit question_path(answer_with_files.question)

      click_on 'Edit'

      within '.answers' do
        attach_file 'Attach files', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'file_field'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
