class ApplicationMailer < ActionMailer::Base
  default from: ENV['DECIDE_SMTP_USERNAME'] || 'from@example.com'
  layout 'mailer'
end
