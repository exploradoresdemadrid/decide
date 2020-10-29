# Preview all emails at http://localhost:3000/rails/mailers/group_mailer
class GroupMailerPreview < ActionMailer::Preview
  def code_submission
    GroupMailer.with(group: Group.first).code_submission
  end
end
