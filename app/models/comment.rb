class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :commentable_type, inclusion: %w[Question Answer]
end
