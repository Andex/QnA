module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating_value
    votes.sum(:value)
  end

  def vote(value, user)
    unless user.voted?(self)
      votes.create(value: value, user_id: user, votable: self)
    else
      votes.where(user_id: user, votable: votable).delete_all
    end
  end
end