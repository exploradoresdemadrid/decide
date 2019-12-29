# frozen_string_literal: true

class VoteSubmissionService
  attr_reader :group, :voting, :option_ids

  def initialize(group, voting, option_ids)
    @group = group
    @voting = voting
    @option_ids = option_ids
  end

  def vote!
    verify_group_presence!
    verify_voting_status!
    verify_options_belong_to_voting!

    unless group.available_votes == option_ids.count
      raise Errors::VotingError, "Number of votes submitted does not match available votes: #{group.available_votes}"
    end

    ActiveRecord::Base.transaction do
      option_ids.each { |option_id| Vote.create!(option_id: option_id) }
      VoteSubmission.create!(group: group, voting: voting, votes_submitted: option_ids.count)
    end
  rescue ActiveRecord::RecordNotUnique
    raise Errors::VotingError, 'The group has already voted'
  rescue ActiveRecord::InvalidForeignKey, ActiveRecord::NotNullViolation
    raise Errors::VotingError, 'One of the options could not be found'
  end

  private

  def verify_group_presence!
    raise Errors::VotingError, 'The group was not provided' unless group.present?
  end

  def verify_voting_status!
    unless voting.open?
      raise Errors::VotingError, "Cannot submit votes for a voting in #{voting.status} status"
    end
  end

  def verify_options_belong_to_voting!
    if Option.joins(:question).where(id: option_ids).where.not('questions.voting_id = ?', voting.id).any?
      raise Errors::VotingError, 'One of the options does not belong to the voting provided'
    end
  end
end
