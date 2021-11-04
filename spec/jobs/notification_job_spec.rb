require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:answer) { create(:answer) }

  before { allow(NotificationService).to receive(:new).and_return(service) }

  it 'calls NotificationService#send_notification' do
    expect(service).to receive(:send_notification)
    NotificationJob.perform_now(answer)
  end
end
