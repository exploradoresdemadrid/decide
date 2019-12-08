# frozen_string_literal: true

class V1::AuthDoc < ApiDoc
  route_base 'api/v1/users/sessions'
  api :create, 'Get voting', http: 'post' do
    security_require :None
    request_body :opt, :json, data: {
      user: {
        email!: String,
        password!: String
      }
    }, desc: 'a JSON'

    response 200, 'Success', :json, data: :VotingListSchema
  end
end
