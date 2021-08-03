class AnswersController < ApplicationController
  before_action :load_question

  def new
    @answer = @question.answers.new
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end
