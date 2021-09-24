class RewardsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @rewards = current_user&.rewards
  end

  def destroy
    @reward = Reward.find(params[:id])
    return unless current_user&.is_author?(@reward.question)

    @reward.destroy
    flash.now.notice = 'Question reward was removed.'
  end
end
