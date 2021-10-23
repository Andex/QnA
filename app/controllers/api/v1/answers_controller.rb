class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %w[index]

  def index
    @answers = @question.answers
    render json: @answers
  end

  private

  def load_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end
end
