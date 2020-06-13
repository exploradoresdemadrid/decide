# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized

        def create
          @user = User.with_valid_auth_token.find_by!(auth_token: user_params[:auth_token])
          bypass_sign_in(@user)

          @user.update_tracked_fields(request)
          @user.save!

          super
        end

        private

        def render_unauthorized
          respond_to do |format|
            format.json { head :unauthorized }
            format.js { redirect_to new_session_path, alert: t('errors.invalid_authentication_code') }
          end
        end

        def user_params
          params.require(:user).permit(:auth_token)
        end
      end
    end
  end
end
