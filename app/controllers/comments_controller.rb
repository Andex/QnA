class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: %w[create]

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new(commentable_params.merge(user: current_user))

    flash.now[:notice] = 'Your comment successfully created.' if @comment.save
    # if current_user && !current_user.is_author?(@commentable)
    #   @commentable.vote(value, current_user)
    #   render_json
    # end
  end

  private

  # def render_json
  #   respond_to do |format|
  #     if @commentable.save
  #       format.json do
  #         render json: { id: @commentable.id, resource: @commentable.class.name.underscore,
  #                        rating: @commentable.rating_value }
  #       end
  #     else
  #       format.json do
  #         render json: @commentable.errors.full_messages, status: :unprocessable_entity
  #       end
  #     end
  #   end
  # end

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
