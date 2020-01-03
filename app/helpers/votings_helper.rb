module VotingsHelper
  def groups_with_vote_submitted(voting)
    string_list(voting.groups.pluck(:name))
  end

  def groups_without_vote_submitted(voting)
    string_list(Group.where.not(id: voting.groups.select(:id)).pluck(:name))
  end
end
