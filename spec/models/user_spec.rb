require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

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

  describe '.find_for_oauth' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect(User.find_for_oauth(auth)).to_not change(User, :count)
        end
      end
    end
  end
end
