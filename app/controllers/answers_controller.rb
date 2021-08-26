class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_answer, only: %w[update destroy]
  before_action :load_question, only: %w[create update]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    end
  end

  def show; end

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
      flash[:alert] = "You cannot delete someone else's question."
    end
    redirect_to question_path(@answer.question)
  end

  private

  def load_question
    # @question = Question.find(params[:question_id])
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
