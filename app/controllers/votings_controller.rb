# frozen_string_literal: true

class VotingsController < ApplicationController
  load_and_authorize_resource

  # GET /votings
  def index
    @votings = Voting.all

    respond_to do |format|
      format.html
      format.json { render json: @votings, adapter: :json }
    end
  end

  # GET /votings/1
  def show
    respond_to do |format|
      format.html
      format.json { render json: @voting, serializer: VotingDetailedSerializer }
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
    @voting = Voting.new(voting_params)

    if @voting.save
      redirect_to @voting, notice: 'Voting was successfully created.'
    else
      render :new
    end
  end


  # PATCH/PUT /votings/1
  def update
    if @voting.update(voting_params)
      redirect_to @voting, notice: 'Voting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /votings/1
  def destroy
    @voting.destroy
    redirect_to votings_url, notice: 'Voting was successfully destroyed.'
  end

  def vote
    VoteSubmissionService.new(current_user.group, Voting.find(params[:voting_id]), params.require(:votes).permit!.to_h).vote!
    respond_to do |format|
      format.html { redirect_to voting_path(@voting) }
      format.json { head :created }
    end
  rescue Errors::VotingError => e
    respond_to do |format|
      format.html { redirect_to voting_path(@voting, error: e.message) }
      format.json { render json: { errors: [e.message] }, status: :bad_request }
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def voting_params
    params.require(:voting).permit(:title, :description, :status, :secret)
  end
end
