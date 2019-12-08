class VotingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status
end