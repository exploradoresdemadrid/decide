class GroupMailer < ApplicationMailer
  def code_submission
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')

    @group = params[:group]
    @organization = @group.organization
    mail(to: @group.email, subject: t('mailers.groups.code_submission.subject')) do |format|
      format.html
      format.text
    end
  end
end
