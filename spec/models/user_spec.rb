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
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      described_class.find_for_oauth(auth)
    end
  end
end
