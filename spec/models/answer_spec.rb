require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  describe '#mark_as_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'the best answer is chosen' do
      answer.mark_as_best

      expect(question.best_answer).to eq answer
    end

    it 'the best answer is not chosen' do
      answer.mark_as_best
      answer.unmark_as_best

      expect(question.best_answer).to_not eq answer
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
