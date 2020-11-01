# frozen_string_literal: true

class GroupsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :group, through: :organization

  def index
    @groups = @organization.groups
                           .accessible_by(current_ability)
                           .includes(:user)
                           .order(number: :asc, name: :asc)
  end

  def show; end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params.merge(organization: current_organization))

    if @group.save
      redirect_to organization_groups_path(@organization),
                  notice: t('activerecord.successful.messages.created', model: Group.model_name.human).capitalize
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to organization_groups_url(@organization),
                  notice: t('activerecord.successful.messages.updated', model: Group.model_name.human).capitalize
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to organization_groups_url(@organization),
                notice: t('activerecord.successful.messages.destroyed', model: Group.model_name.human).capitalize
  end

  def reset_token
    current_organization.users.with_group.each(&:reset_token)
    redirect_to organization_groups_url(@organization), notice: t('groups.tokens_updated')
  end

  def email_token
    current_organization.groups.where.not(email: nil).each do |group|
      GroupMailer.with(group: group).code_submission.deliver_later
    end

    redirect_to organization_groups_url(@organization), notice: t('groups.token_emails_submitted')
  end

  def bulk_upload_show; end

  def bulk_upload_template
    send_data CsvGroupExporter.new(current_organization).export!, filename: "#{t('activerecord.models.group.many')}-#{Date.today}.csv"
  end

  def bulk_upload_create
    groups = CsvGroupImporter.new(current_organization, bulk_upload_params[:import]).import!

    redirect_to organization_groups_url(@organization), 
                notice: t('activerecord.successful.messages.bulk_updated', count: groups.count, model: t('activerecord.models.group.many'))
  rescue CsvGroupImporter::CSVParseError => e
    redirect_to bulk_upload_show_organization_groups_url(@organization), alert: e.message
  end

  private

  def group_params
    params.require(:group).permit(:name, :number, :available_votes, :email, bodies_groups_attributes: [:id, :votes])
  end

  def bulk_upload_params
    params.require(:group).permit(:import)
  end
end
