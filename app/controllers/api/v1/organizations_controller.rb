module Api
  module V1
    class OrganizationsController < ApplicationController
      def create_test
        name = "#{Organization::SMOKETEST_CODE}_1"
        Organization.destroy_by(name: name)
        Organization.new(
          name: name,
          admin_email: ENV['SMOKETEST_EMAIL'],
          admin_password: ENV['SMOKETEST_PASSWORD']
        ).save!
        render json: {}, status: :created
      end
    end
  end
end
