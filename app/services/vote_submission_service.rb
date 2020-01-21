# frozen_string_literal: true

class VoteSubmissionService
  attr_reader :group, :voting, :response

  def initialize(group, voting, response)
    @group = group
    @voting = voting
    @response = response.transform_values{ |v| v.transform_values(&:to_i) }
  end

  def vote!
    verify_group_presence!
    verify_voting_status!
    verify_questions_belong_to_voting!
    verify_options_belong_to_question!

    unless response.size == voting.questions.count
      raise Errors::VotingError, 'Votes for some of the questions are missing'
    end

    unless response.values.all? { |question_responses| question_responses.values.sum == group.available_votes }
      raise Errors::VotingError, "Number of votes submitted does not match available votes: #{group.available_votes}"
    end

    ActiveRecord::Base.transaction do
      response.values.inject(:merge).each do |option_id, votes|
        votes.times { Vote.create!(option_id: option_id, group_id: stored_group_id) }
      end
      VoteSubmission.create!(group: group, voting: voting, votes_submitted: group.available_votes)
    end
  rescue ActiveRecord::RecordNotUnique
    raise Errors::VotingError, 'The group has already voted'
  rescue ActiveRecord::InvalidForeignKey, ActiveRecord::NotNullViolation
    raise Errors::VotingError, 'One of the options could not be found'
  rescue ActiveRecord::RecordInvalid => e
    raise Errors::VotingError, e.message.split(':').last.strip
  end

  private

  def verify_group_presence!
    unless group.present?
      raise Errors::VotingError, 'The group was not provided'
    end
  end

  def verify_voting_status!
    unless voting.open?
      raise Errors::VotingError, "Cannot submit votes for a voting in #{voting.status} status"
    end
  end

  def verify_questions_belong_to_voting!
    if Question.where(id: question_ids).where.not('questions.voting_id = ?', voting.id).any?
      raise Errors::VotingError, 'One of the questions does not belong to the voting provided'
    end
  end

  def verify_options_belong_to_question!
    response.map { |k, v| [k, v.keys] }.to_h.each do |question_id, option_ids|
      if Option.where(id: option_ids).where.not(question_id: question_id).any?
        raise Errors::VotingError, 'One of the options does not belong to the question provided'
      end
    end
  end

  def question_ids
    response.keys
  end

  def stored_group_id
    group.id unless voting.secret?
  end
end
