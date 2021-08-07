class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_question, only: :create
  before_action :load_answer, only: :destroy

  def new;  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @answer, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def show; end

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
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
