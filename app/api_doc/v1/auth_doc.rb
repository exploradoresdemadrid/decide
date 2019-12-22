# frozen_string_literal: true

class V1::AuthDoc < ApiDoc
  route_base 'api/v1/users/sessions'

  components do
    schema UserResponseSchema: [
      {
        id: String,
        email: String
      },
      dft: {}
    ]
  end

  api :create, 'Sign in', http: 'post' do
    security_require :None
    request_body :opt, :json, data: {
      user: {
        auth_token!: String
      }
    }, desc: 'a JSON'

    response 200, 'Success', :json, data: :UserResponseSchema
  end
end
