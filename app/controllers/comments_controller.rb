class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @comment = Comment.new
  end

  def create
    authorize! :destroy, Comment
    @commentable = load_commentable
    @comment = @commentable.comments.new(commentable_params.merge(user: current_user))

    flash.now[:notice] = 'Your comment successfully created.' if @comment.save
    publish_comment('create')
  end

  def destroy
    @comment = current_user&.comments.find_by(id: params[:id])
    authorize! :destroy, @comment
    @commentable = @comment&.commentable
    flash.now.notice = 'Your comment was removed.' if @comment&.destroy
    publish_comment('destroy')
  end

  private

  def publish_comment(event)
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments/question-#{@commentable.is_a?(Question) ? @commentable.id : @commentable.question.id}",
      comment: @comment,
      user_email: current_user.email,
      event: event
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
