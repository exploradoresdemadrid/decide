class VotingTimeoutUpdater
  include Sidekiq::Worker

  def perform(voting_id)
    voting = Voting.find voting_id
    if voting.open?
      voting.finished!
      Rails.logger.info "Voting with id #{voting_id} was updated to finished status"
    end
  end
end