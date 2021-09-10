class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %w[index show]
  before_action :load_question, only: %w[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @new_answer = @question.answers.new
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if current_user.is_author?(@question)
      @question.update(question_params)
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
    params.require(:question).permit(:title, :body, files: [])
  end
end
