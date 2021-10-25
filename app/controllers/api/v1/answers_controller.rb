class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: %w[show]
  before_action :load_question, only: %w[index show]

  authorize_resource class: Answer

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  private

  def load_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
