require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'subscribe_question' do
    let!(:user) { create(:user) }
    # let!(:question) { create(:question) }
    # let!(:answer) { create(:answer, question: question) }
    let!(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.subscribe_question(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq('Notification of a new answer to a question')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('Updating question:')
    end
  end
end
