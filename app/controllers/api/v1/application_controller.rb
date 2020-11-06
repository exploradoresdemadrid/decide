module Api
  module V1
    class ApplicationController < ActionController::API
      before_action :authenticate!

      private

      def authenticate!
        head :unauthorized unless bearer_token == ENV['API_TOKEN']
      end

      def bearer_token
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        header.gsub(pattern, '') if header&.match(pattern)
      end
    end
  end
end
