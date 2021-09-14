class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def unmark_as_best
    question.update(best_answer_id: nil)
  end
end
