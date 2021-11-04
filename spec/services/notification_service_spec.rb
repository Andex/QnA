require 'rails_helper'

RSpec.describe NotificationService do
  let(:users){ create_list(:user, 3) }
  let(:answer) { create(:answer) }

  it 'sends notification of a new answer to a question' do
    users.each { |user| expect(NotificationMailer).to receive(:subscribe_question).with(user, answer).and_call_original }
    subject.send_notification(answer)
  end
end
