class OrganizationsController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: [:new, :create]

  # GET /organizations
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      unless current_user
        user = User.find_by(email: organization_params[:admin_email])
        bypass_sign_in(user)
        user.update_tracked_fields(request)
      end
      redirect_to @organization, notice: t('activerecord.successful.messages.created', model: Organization.model_name.human).capitalize
    else
      render :new
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: t('activerecord.successful.messages.updated', model: Organization.model_name.human).capitalize
    else
      render :edit
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: t('activerecord.successful.messages.destroyed', model: Organization.model_name.human).capitalize
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def organization_params
      params.require(:organization).permit(:name, :admin_email, :admin_password, :member_type)
    end
end
