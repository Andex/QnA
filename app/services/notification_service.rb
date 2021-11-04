class NotificationService
  def send_notification(answer)
    subscriptions = answer.question.subscriptions

    subscriptions.find_each(batch_size: 500) do |subscriptions|
      NotificationMailer.subscribe_question(subscriptions.user, answer).deliver_later
    end
  end
end
