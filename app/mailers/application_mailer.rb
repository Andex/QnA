class ApplicationMailer < ActionMailer::Base
  default from: %("Questions&Answers" <mail@qna.com>)
  layout 'mailer'
end
