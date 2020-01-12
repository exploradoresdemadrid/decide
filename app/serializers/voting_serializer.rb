class VotingSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :secret

  attribute :already_voted

  def already_voted
    scope.current_user.group.voted?(object)
  end
end