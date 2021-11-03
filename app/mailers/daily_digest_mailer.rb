class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_in_a_day

    mail to: user.email, subject: 'Daily Digest' if @questions.present?
  end
end
