require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['mail@qna.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Daily Digest from QnA')
    end
  end
end
