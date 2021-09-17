require 'rails_helper'

feature 'User can assign reward to question', %q{
  In order to reward the best answer to my question
  As an question's author
  I'd like to be able to assign reward
} do
  given(:user) { create(:user) }
  given(:reward_image) { create(:reward) }

  before do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Details', with: 'text text'
  end

  scenario 'User assigns reward when asks question' do
    fill_in 'Title', with: 'Reward'
    attach_file 'Image', "#{Rails.root}/public/reward.png"

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