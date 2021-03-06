require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_inclusion_of(:commentable_type).in_array(%w[Question Answer]) }
end
