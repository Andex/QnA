class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
