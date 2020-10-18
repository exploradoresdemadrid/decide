# frozen_string_literal: true

class VotingsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :voting, through: :organization

  # GET /votings
  def index
    all_votings = @organization.votings.accessible_by(current_ability).includes(:questions)
    @non_archived_votings = all_votings.where.not(status: :archived)
    @archived_votings = @votings.archived
    respond_to do |format|
      format.html
    end
  end

  # GET /votings/1
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /votings/new
  def new
    @voting = Voting.new
  end

  # GET /votings/1/edit
  def edit; end

  # POST /votings
  def create
    @voting = get_model(voting_params[:type]).new(voting_params.merge(organization: current_organization))

    if @voting.save
      redirect_to organization_voting_url(@organization, @voting), notice: 'Voting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /votings/1
  def update
    if @voting.update(voting_params)
      redirect_to organization_voting_url(@organization, @voting), notice: 'Voting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /votings/1
  def destroy
    @voting.destroy
    redirect_to organization_votings_url(@organization), notice: 'Voting was successfully destroyed.'
  end

  def vote
    voting = Voting.find(params[:voting_id])
    VoteSubmissionService.new(current_user.group, voting, params.require(:votes).permit!.to_h).vote!
    respond_to do |format|
      format.html { redirect_to organization_voting_path(@organization, voting) }
    end
  rescue Errors::VotingError => e
    respond_to do |format|
      format.html { redirect_to organization_voting_path(@organization, voting), error: e.message }
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def voting_params
    params.require(:voting).permit(:title, :description, :status, :secret, :type, :max_options, :options, :timeout_in_seconds, :body_id)
  end

  def get_model(type)
    type.singularize.camelize.constantize
  end
end
