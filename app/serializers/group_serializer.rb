class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :number, :available_votes
end