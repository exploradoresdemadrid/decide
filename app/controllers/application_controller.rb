# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  add_flash_types :error

  private

  def current_organization
    current_user.organization
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || votings_path
  end
end
