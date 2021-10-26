class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: %w[show update]
  before_action :load_question, only: %w[index show create]

  authorize_resource class: Answer

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params.merge(question_id: params[:question_id]))

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id, links_attributes: %i[name url id])
  end

  def load_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
