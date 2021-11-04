class NotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotificationService.new.send_notification(answer)
  end
end
