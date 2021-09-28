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
      votes.new(value: value, user_id: user.id)
    else
      votes.where(user_id: user.id).delete_all
    end
  end
end