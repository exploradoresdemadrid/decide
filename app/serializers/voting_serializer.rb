class VotingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :secret
end