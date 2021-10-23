class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_one :reward
  has_many :links
  has_many :comments
  has_many :files, each_serializer: AttachmentSerializer
  belongs_to :user
end
