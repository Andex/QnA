class RewardsController < ApplicationController
  before_action :authenticate_user!, except: %w[index show]

  def index
    @rewards = current_user&.rewards
  end

  def destroy
    @reward = Reward.find(params[:id])
    if current_user&.is_author?(@reward.question)
      @reward.user.rewards.delete(@reward) if @reward.user.present?
      @reward.destroy
      flash.now.notice = 'Question reward was removed.'
    end
  end
end
