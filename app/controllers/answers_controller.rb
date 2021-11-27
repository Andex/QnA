class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: %w[update destroy best]
  before_action :load_question, only: %w[create update best destroy]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    flash.now[:notice] = 'Your answer successfully created.' if @answer.save
    publish_question('add')
  end

  def update
    @answer.update(answer_params.except(:files))
    attach_files(@answer)
    flash.now[:notice] = 'Your answer was successfully edited.'
    publish_question('update')
  end

  def destroy
    @answer.unmark_as_best if @answer == @question.best_answer

    @answer.destroy
    flash.now[:notice] = 'Your answer was successfully deleted.'
    publish_question('destroy')
  end

  def best
    @answer.mark_as_best
  end

  private

  def load_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, files: [], links_attributes: %i[name url id destroy])
  end

  def attach_files(answer)
    answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
  end

  def publish_question(event)
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}",
      answer: @answer,
      links: @answer.links,
      event: event
    )
  end
end
