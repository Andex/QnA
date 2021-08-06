class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %w[show]
  before_action :load_question, only: :create

  def new;  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def show; end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
