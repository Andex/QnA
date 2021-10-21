class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :short_body
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(8)
  end

  def short_body
    object.body.truncate(10)
  end
end
