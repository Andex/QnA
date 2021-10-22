require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe 'Best answer' do
    let(:question) { create(:question, :with_reward) }
    let(:answer) { create(:answer, question: question) }

    it '#mark_as_best' do
      answer.mark_as_best

      expect(question.best_answer).to eq answer
      expect(question.reward.user).to eq answer.user
    end

    it '#unmark_as_best' do
      answer.mark_as_best
      answer.unmark_as_best

      expect(question.best_answer).to_not eq answer
      expect(question.reward.user).to eq nil
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
