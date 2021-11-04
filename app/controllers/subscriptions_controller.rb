class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.new(question: @question) unless current_user.subscribed?(@question)

    flash.now[:notice] = 'You have successfully subscribed to updates on this question' if @subscription&.save
  end

  def destroy
    @subscription = current_user.subscriptions&.find_by(question_id: params[:id])
    @subscription&.destroy
    flash.now.notice = 'Your subscription was removed.'
  end
end
