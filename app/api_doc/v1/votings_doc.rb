# frozen_string_literal: true

class V1::VotingsDoc < ApiDoc
  route_base 'votings'
  components do
    schema VotingResponseSchema: [
      {
        id: String,
        title: String,
        description: String,
        status: String
      },
      dft: {}
    ]
    schema VotingListSchema: [
      {
        votings: Array[:VotingResponseSchema]
      },
      dft: {}
    ]
    schema BadRequestSchema: [
      { errors: Array[String] }, dft: {}
    ]

    response NotFoundResponse: ['Not found', :json, data: {}]
    response BadRequestResponse: ['Bad request', :json, data: :BadRequestSchema]
    response VotingResponse: ['Voting', :json, data: :VotingResponseSchema]
  end

  api :index do
    response 200, 'Success', :json, data: :VotingListSchema
  end

  api :show, 'Get voting', http: 'get' do
    path :id, String
    param :path, :id, String, :req, desc: 'UUID of the voting'
    response_ref 202 => :VotingResponse
    response_ref 400 => :BadRequestResponse
    response_ref 404 => :NotFoundResponse
  end
end
