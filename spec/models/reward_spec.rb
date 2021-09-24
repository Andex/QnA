require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional(true) }

  it { should validate_presence_of :title}
  it { should validate_attached_of :image}
  it { should validate_content_type_of(:image).allowing('image/png', 'image/jpeg', 'image/jpg') }
  # it { should validate_content_type_of(:image).allowing('image/bmp', 'image/jpg') }
  # it { should validate_content_type_of(:image).allowing('image/jpeg', 'image/jpg') }
  # it { should validate_content_type_of(:image).allowing('image/png') }
  # it { should validate_content_type_of(:image).allowing('image/jpeg') }
  # it { should validate_content_type_of(:image).allowing('image/jpg') }

  it 'has one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
