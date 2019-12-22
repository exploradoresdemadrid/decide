# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized

        def create
          @user = User.with_valid_auth_token.find_by!(auth_token: user_params[:auth_token])
          bypass_sign_in(@user)

          super
        end

        private

        def render_unauthorized
          head :unauthorized
        end

        def user_params
          params.require(:user).permit(:auth_token)
        end

        def respond_with(resource, _opts = {})
          render json: resource
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end
