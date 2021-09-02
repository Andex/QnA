class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true

  def other_answers
    best_answer ? answers.where.not(id: best_answer_id) : answers
  end
end
