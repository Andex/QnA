require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  describe '#vote' do
    let(:user) { create(:user) }

    it 'when action to vote up' do
      votable.vote(1, user)

      expect(votable.votes.last.value).to eq 1
    end

    it 'when action to vote down' do
      votable.vote(-1, user)

      expect(votable.votes.last.value).to eq(-1)
    end

    it 'when action to cancel vote' do
      votable.vote(1, user)
      votable.vote(0, user)

      expect(votable.rating_value).to eq 0
    end
  end

  describe '#rating_value' do
    let(:users){ create_list(:user, 4) }

    it '#rating_value' do
      users.each do |user|
        votable.vote(1, user)
      end
      votable.vote(0, users.last)
      votable.vote(-1, users.last)

      expect(votable.rating_value).to eq 2
    end
  end
end
