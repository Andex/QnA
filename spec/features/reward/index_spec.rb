require 'rails_helper'

feature 'User can view a list of his rewards', "
  As un authenticated user
  I'd like to be able to view a list of my rewards for my answers
" do
  given(:user) { create(:user, :with_rewards) }

  scenario 'User views a list of questions' do
    login(user)
    visit rewards_path

    expect(page).to have_content 'My rewards'

    user.rewards.each do |reward|
      expect(page).to have_content reward.question.title
      expect(page).to have_content reward.title
      expect(page).to have_css 'img'
    end
  end
end
