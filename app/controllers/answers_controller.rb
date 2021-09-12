class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %w[update destroy best]
  before_action :load_question, only: %w[create update best destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    flash.now[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    if current_user.is_author?(@answer)
      @answer.update(answer_params.except(:files))
      attach_files(@answer)
      flash.now[:notice] = 'Your answer was successfully edited.'
    else
      flash.now[:alert] = "You cannot edit someone else's answer."
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.unmark_as_best if @answer == @question.best_answer

      @answer.destroy
      flash.now[:notice] = 'Your answer was successfully deleted.'
    else
      flash.now[:alert] = "You cannot delete someone else's answer."
    end
  end

  def best
    @answer.mark_as_best if current_user.is_author?(@question)
  end

  private

  def load_question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, files: [])
  end

  def attach_files(answer)
    answer.files.attach(params[:answer][:files]) if params[:answer][:files].present?
  end
end
