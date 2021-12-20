class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :send_notifications

  def mark_as_best
    transaction do
      question.update!(best_answer_id: id)
      question.reward&.update!(user: user)
    end
  end

  def unmark_as_best
    transaction do
      question.update!(best_answer_id: nil)
      question.reward&.update!(user: nil)
    end
  end

  private

  def send_notifications
    NotificationJob.perform_later(self)
  end
end
