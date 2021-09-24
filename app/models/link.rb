class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true
  validates :linkable_type, inclusion: %w[Question Answer]

  def gist?
    url.include?('gist.github.com')
  end
end
