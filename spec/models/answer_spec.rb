require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#mark_as_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'the best answer is chosen' do
      answer.mark_as_best

      expect(question.best_answer).to eq answer
    end
  end
end
