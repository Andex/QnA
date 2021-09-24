require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable}

  it { should validate_presence_of :name}
  it { should validate_presence_of :url}
  it { should validate_url_of :url}
  it { should validate_inclusion_of(:linkable_type).in_array(%w[Question Answer]) }

  describe '#gist?' do
    let(:gist_link) { create(:link, :gist) }
    let(:link) { create(:link) }

    it 'link to gist' do
      expect(gist_link).to be_gist
    end

    it 'link not to gist' do
      expect(link).to_not be_gist
    end
  end
end
