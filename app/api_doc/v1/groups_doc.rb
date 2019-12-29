# frozen_string_literal: true

class V1::AuthDoc < ApiDoc
  route_base 'groups'

  components do
    schema GroupResponseSchema: [
      {
        id: String,
        name: String,
        number: Integer,
        available_votes: Integer
      },
      dft: {}
    ]
  end

  api :current, 'My group', http: 'get' do
    response 200, 'Success', :json, data: :GroupResponseSchema
  end
end
