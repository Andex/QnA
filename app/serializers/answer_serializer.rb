class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :links
  has_many :files, each_serializer: AttachmentSerializer
  has_many :comments

  belongs_to :question
  belongs_to :user
end
