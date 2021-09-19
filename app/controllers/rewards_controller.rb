class RewardsController < ApplicationController
  before_action :authenticate_user!, except: %w[index show]

  def index
    @rewards = current_user.rewards&.all
  end
end

