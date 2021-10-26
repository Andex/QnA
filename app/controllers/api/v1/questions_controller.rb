class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update]

  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, each_serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id],
                                                    reward_attributes: %i[title image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
