class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true
  validates :image, content_type: %w[jpg jpeg png]
end
