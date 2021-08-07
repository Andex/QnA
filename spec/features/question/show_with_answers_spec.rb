require 'rails_helper'

feature 'User can view the question with answers of it', "
  In order to view all answers for question
  As un user
  I'd like to be able to view the question with answers of it
" do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User view the question with answers of it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
