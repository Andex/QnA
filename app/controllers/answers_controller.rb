class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_answer, only: %w[update destroy best]
  before_action :load_question, only: %w[create update best destroy]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    flash[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def update
    if current_user.is_author?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Your answer was successfully edited.'
    else
      flash[:alert] = "You cannot edit someone else's answer."
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    else
      flash[:alert] = "You cannot delete someone else's answer."
    end
  end

  def best
    @answer.mark_as_best if current_user.is_author?(@question)
  end

  private

  def load_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
