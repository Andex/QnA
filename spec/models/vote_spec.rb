require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :value }
  it { should validate_numericality_of(:value).only_integer }

  describe 'uniqueness of user scoped to votable' do
    let(:user){ create(:user) }
    let(:answer){ create(:answer, question: question) }
    let(:question){ create(:question) }
    let!(:voted){ create(:vote, votable: answer, user: user) }
    let!(:voted){ create(:vote, votable: question, user: user) }

    it { should validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }
  end
end
