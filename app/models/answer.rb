class Answer < ApplicationRecord
  include Votable

  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

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
end
