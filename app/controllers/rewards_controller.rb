class RewardsController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :authenticate_user!, except: :index

  authorize_resource

  def index
    @rewards = current_user&.rewards
  end

  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    flash.now.notice = 'Question reward was removed.'
  end
end
