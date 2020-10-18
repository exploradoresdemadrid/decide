# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    redirect_to organization_votings_path(current_user.organization) if current_user.present?
  end
end
