class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, numericality: { only_integer: true }
  validates :user, uniqueness: { scope: %i[votable_id votable_type] }
  validates :votable_type, inclusion: %w[Question Answer]
end
