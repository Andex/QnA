class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def new
    @comment = Comment.new
  end

  def create
    @commentable = load_commentable
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

  def commentable_id
    "#{commentable_name}_id".to_sym
  end

  def load_commentable
    params.each do |name, value|
      return Regexp.last_match(1).classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end

  def commentable_params
    params.require(:comment).permit(:body)
  end
end
