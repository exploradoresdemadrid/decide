# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  def index
    @groups = Group.includes(:user).all
  end

  def show; end

  def current
    @group = current_user.group
    respond_to do |format|
      format.json { render json: @group, status: :ok }
    end
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to groups_path, notice: 'Group was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
    end
  end

  def reset_token
    User.with_group.each(&:reset_token)
    redirect_to groups_url, notice: 'The Groups Tokens have been updated.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :number, :available_votes)
  end
end
