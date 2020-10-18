class BodiesController < ApplicationController
  load_and_authorize_resource :body
  load_resource :organization
  before_action :set_body, only: [:show, :edit, :update, :destroy]

  # GET /bodies
  def index
    @bodies = @organization.bodies.accessible_by(current_ability)
  end

  # GET /bodies/1
  def show
  end

  # GET /bodies/new
  def new
    @body = Body.new
  end

  # GET /bodies/1/edit
  def edit
  end

  # POST /bodies
  def create
    @body = Body.new(body_params.merge(organization: @organization))

    if @body.save
      redirect_to organization_body_path(@organization, @body), notice: 'Body was successfully created.'
    else
      render :new, alert: @body.errors
    end
  end

  # PATCH/PUT /bodies/1
  def update
    if @body.update(body_params)
      redirect_to organization_body_path(@organization, @body), notice: 'Body was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bodies/1
  def destroy
    @body.destroy
    redirect_to organization_bodies_url(@organization), notice: 'Body was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_body
      @body = Body.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def body_params
      params.require(:body).permit(:name, :default_votes)
    end
end
