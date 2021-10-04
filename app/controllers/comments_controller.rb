class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: %w[create @commentable]
  after_action :publish_comment, only: :create

  def new
    @comment = Comment.new
  end

  def create
    if current_user && !current_user.is_author?(@commentable)
      @comment = @commentable.comments.new(commentable_params.merge(user: current_user))

      flash.now[:notice] = 'Your comment successfully created.' if @comment.save
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments/question-#{@commentable.is_a?(Question) ? @commentable.id : @commentable.question.id}",
      comment: @comment,
      user_email: current_user.email
    )
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_id
    "#{commentable_name}_id".to_sym
  end

  def load_commentable
    @commentable = commentable_name.classify.constantize.find(params[commentable_id])
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end
end
