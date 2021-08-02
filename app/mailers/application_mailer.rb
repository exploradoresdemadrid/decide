class ApplicationMailer < ActionMailer::Base

  before_action { attachments.inline['logo.png'] = File.read('app/assets/images/logo.png') }

  default from: ENV['DECIDE_SMTP_USERNAME'] || 'from@example.com'
  layout 'mailer'
  add_template_helper(MailHelper)
end
