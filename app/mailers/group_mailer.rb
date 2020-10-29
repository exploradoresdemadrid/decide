class GroupMailer < ApplicationMailer
  def code_submission
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')

    @group = params[:group]
    mail(to: @group.email) do |format|
      format.html
      format.text
    end
  end
end
