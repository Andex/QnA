require 'rails_helper'

feature 'User can change answer rating by voting', "
  In order to vote up or down a answer
  As un authenticated user
  I'd like to be able vote up or down a answer
" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Unauthenticated user' do
    scenario "can't to change answer rating by voting" do
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to change answer rating by voting' do
      login(answer.user)
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated user', js: true do
    before do
      login(question.user)
      visit question_path(question)
    end

    scenario 'vote up a answer' do
      within ".answer-id-#{answer.id} .rating" do
        click_on 'UP'

        expect(page).to have_content '1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote down a answer' do
      within ".answer-id-#{answer.id} .rating" do
        click_on 'DOWN'

        expect(page).to have_content '-1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote cancel a answer' do
      within ".answer-id-#{answer.id} .rating" do
        click_on 'UP'

        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'

        click_on 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'UP'
        expect(page).to have_link 'DOWN'
      end
    end
  end
end