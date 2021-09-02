require 'rails_helper'

feature 'The author of the question can choose the best answer for his question', "
  In order to choose the best answer of question
  As un author of the question
  I'd like to be able choose the best answer of question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:question_with_best_answer) { create(:question, :with_best_answer) }
  given(:first_best_answer) { question_with_best_answer.best_answer }
  given!(:another_answer) { create(:answer, question: question_with_best_answer) }

  describe 'Authenticated author of the question' do
    scenario 'choose the best answer for his question' do
      login(question.user)
      visit question_path(question)

      within ".answer-id-#{answers.first.id}" do
        click_on 'Choose the best'
      end

      within ".best-answer" do
        expect(page).to have_content '👍'
        expect(page).to have_content answers.first.body
      end

      within ".other-answers" do
        expect(page).to_not have_content answers.first.body
      end
    end

    scenario 'choose another better answer for his question' do
      login(question_with_best_answer.user)
      visit question_path(question_with_best_answer)

      within ".best-answer" do
        expect(page).to have_content '👍'
        expect(page).to have_content question_with_best_answer.best_answer.body
      end

      within ".answer-id-#{another_answer.id}" do
        click_on 'Choose the best'
      end

      within ".best-answer" do
        expect(page).to have_content '👍'
        expect(page).to have_content another_answer.body
        expect(page).to_not have_content first_best_answer.body
      end

      within ".other-answers" do
        expect(page).to_not have_content another_answer.body
      end
    end
  end

  scenario 'Unauthenticated user can not choose the best answer of question' do
    visit question_path(question)

    expect(page).to_not have_button 'Choose the best'
  end

  scenario "Authenticated user tries to choose the best answer of question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_button 'Choose the best'
  end
end
