class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true

  after_create :subscribe_author

  scope :created_in_a_day, -> { where("created_at >= :today", today: DateTime.current.beginning_of_day) }

  def other_answers
    best_answer ? answers.where.not(id: best_answer_id) : answers
  end

  private

  def subscribe_author
    subscriptions.create!(user: user)
  end
end
