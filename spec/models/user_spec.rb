require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe '#is_author' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }

    it 'user is an author' do
      expect(question.user).to be_is_author(question)
      expect(answer.user).to be_is_author(answer)
    end

    it 'current user is not an author' do
      expect(user).not_to be_is_author(question)
      expect(user).not_to be_is_author(answer)
    end
  end
end
