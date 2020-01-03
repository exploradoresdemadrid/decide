# frozen_string_literal: true

module VotingsHelper
  def groups_with_vote_submitted(voting)
    string_list(voting.groups.pluck(:name))
  end

  def groups_without_vote_submitted(voting)
    string_list(Group.where.not(id: voting.groups.select(:id)).pluck(:name))
  end

  def secret_voting_alert(voting)
    alert_box do
      if voting.secret?
        'This voting is secret. The votes submitted will not be associated to your group.'
      else
        'This voting is not secret. The votes submitted will be associated to your group, and will be visible in the results.'
      end
    end
  end
end
