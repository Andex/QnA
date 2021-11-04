# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification/sub
  def subscribe_question
    NotificationMailer.subscribe_question
  end
end
