require 'rails_helper'

feature 'User can assign reward to question', "
  In order to reward the best answer to my question
  As an question's author
  I'd like to be able to assign reward
" do
  describe 'When creating a question', js: true do
    given(:user) { create(:user) }

    before do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Title'
      fill_in 'Details', with: 'text text'
    end

    scenario 'User assigns reward when asks question' do
      fill_in 'Reward title', with: 'Reward'
      attach_file 'Image', "#{Rails.root}/spec/files/reward.png"

      click_on 'Ask'

      visit questions_path
      expect(page).to have_content 'Reward'
    end

    scenario 'User assigns reward with errors when asks question' do
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Ask'

      expect(page).to have_content "Reward title can't be blank"
      expect(page).to have_content 'Reward image has an invalid content type'
    end
  end

  describe 'When editing a question', js: true do
    given(:question) { create(:question) }

    before do
      login(question.user)
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'User assigns a reward when editing his question' do
      fill_in 'Reward title', with: 'New reward'
      attach_file 'Image', "#{Rails.root}/spec/files/reward.png"

      click_on 'Save'

      expect(page).to have_content 'New reward'
    end

    scenario 'User assigns reward with errors when edited his question' do
      fill_in 'Reward title', with: ''
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_content "Reward title can't be blank"
      expect(page).to have_content 'Reward image has an invalid content type'
    end
  end
end
