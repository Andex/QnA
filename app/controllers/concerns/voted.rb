module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: %w[vote_up vote_down cancel_vote render_json]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def cancel_vote
    vote(0)
  end

  private

  def vote(value)
    authorize! :vote, @votable
    @votable.vote(value, current_user)
    render_json
  end

  def render_json
    respond_to do |format|
      if @votable.save
        format.json do
          render json: { id: @votable.id, resource: @votable.class.name.underscore,
                         rating: @votable.rating_value }
        end
      else
        format.json do
          render json: @votable.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_klass.find(params[:id])
  end
end
