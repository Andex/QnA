class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %w[index show]
  before_action :load_question, only: %w[show edit update destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
    gon.current_user_id = current_user&.id
  end

  def show
    @new_answer = @question.answers.new
    @new_answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.is_author?(@question)
      @question.update(question_params.except(:files))
      attach_files(@question)
      flash.now[:notice] = 'Your question was successfully updated.'
    else
      flash.now[:alert] = "You cannot update someone else's question."
    end
  end

  def destroy
    if current_user.is_author?(@question)
      @question.update(best_answer_id: nil) if @question.best_answer

      @question.destroy
      redirect_to questions_path, notice: 'Your question was successfully deleted.'
    else
      redirect_to question_path(@question), alert: "You cannot delete someone else's question."
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id _destroy],
                                     reward_attributes: %i[id title image _destroy])
  end

  def attach_files(question)
    question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end

  def publish_question
    return if @question.errors.any?
    url = @question.reward.image.url if @question.reward

    ActionCable.server.broadcast(
      'questions',
      question: @question,
      reward: @question.reward.as_json,
      url: url
    )
  end
end
