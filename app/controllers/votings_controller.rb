class VotingsController < ApplicationController
  before_action :set_voting, only: [:show, :edit, :update, :destroy]

  # GET /votings
  def index
    @votings = Voting.all
  end

  # GET /votings/1
  def show
  end

  # GET /votings/new
  def new
    @voting = Voting.new
  end

  # GET /votings/1/edit
  def edit
  end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voting
      @voting = Voting.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def voting_params
      params.require(:voting).permit(:title, :description, :status)
    end
end
