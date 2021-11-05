require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'subscribe_question' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.subscribe_question(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Updating question: #{answer.question.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['mail@qna.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content('New answer to subscribed Question has been posted:')
    end
  end
end
