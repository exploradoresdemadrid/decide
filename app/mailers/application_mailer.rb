class ApplicationMailer < ActionMailer::Base
  default from: ENV['DECIDE_SMTP_USERNAME'] || 'from@example.com'
  layout 'mailer'
  add_template_helper(MailHelper)
end
