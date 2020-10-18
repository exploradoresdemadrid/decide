# frozen_string_literal: true

class GroupsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :group, through: :organization

  def index
    @groups = @organization.groups.accessible_by(current_ability).includes(:user).all
  end

  def show; end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params.merge(organization: current_organization))

    respond_to do |format|
      if @group.save
        format.html { redirect_to organization_groups_url(@organization), notice: 'Group was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to organization_groups_url(@organization), notice: 'Group was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to organization_groups_url(@organization), notice: 'Group was successfully destroyed.' }
    end
  end

  def reset_token
    current_organization.users.with_group.each(&:reset_token)
    redirect_to organization_groups_url(@organization), notice: 'The Groups Tokens have been updated.'
  end

  def bulk_upload_show; end

  def bulk_upload_create
    groups = CsvGroupImporter.new(current_organization, bulk_upload_params[:import]).import!

    respond_to do |format|
      format.html { redirect_to organization_groups_url(@organization), notice: t('groups_updated', count: groups.count) }
    end
  rescue CsvGroupImporter::CSVParseError => e
    redirect_to bulk_upload_show_organization_groups_url(@organization), alert: e.message
  end

  private

  def group_params
    params.require(:group).permit(:name, :number, :available_votes, bodies_groups_attributes: [:id, :votes])
  end

  def bulk_upload_params
    params.require(:group).permit(:import)
  end
end
