require 'rails_helper'

feature 'User can view a list of questions', %q{
  As un user
  I'd like to be able to view a list of questions
} do
  given!(:questions) { create_list(:question, 2) }

  scenario 'User view a list of questions' do
    visit questions_path

    expect(page).to have_content 'All questions'

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.first.body
    expect(page).to have_content questions.second.title
    expect(page).to have_content questions.second.body
  end
end