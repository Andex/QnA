module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating_value
    votes.sum(:value)
  end

  def vote(value, user)
    if user.voted?(self)
      votes.where(user_id: user.id).delete_all
    else
      votes.create(value: value, user_id: user.id)
    end
  end
end
