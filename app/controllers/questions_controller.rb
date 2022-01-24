class QuestionsController < ApplicationController
  include ActiveStorage::SetCurrent
  include Voted

  before_action :authenticate_user!, except: %w[index show]
  before_action :load_question, only: %w[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
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
      publish_question('add')
    else
      @question.build_reward
      render :new
    end
  end

  def update
    return unless @question.update(question_params.except(:files))

    attach_files(@question)
    flash[:notice] = 'Your question was successfully updated.'
    publish_question('update')
  end

  def destroy
    @question.best_answer.unmark_as_best if @question.best_answer

    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
    publish_question('destroy')
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id _destroy],
                                     reward_attributes: %i[title image _destroy])
  end

  def attach_files(question)
    question.files.attach(params[:question][:files]) if params[:question][:files].present?
  end

  def publish_question(event)
    return if @question.errors.any?
    url = @question.reward.image.url if @question.reward

    ActionCable.server.broadcast(
      'questions',
      question: @question,
      reward: @question.reward.as_json,
      url: url,
      event: event
    )
  end
end
