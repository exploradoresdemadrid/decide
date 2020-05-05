# frozen_string_literal: true

class MultiselectVoting < Voting
  validates_numericality_of :max_options, greater_than_or_equal_to: 0, only_integer: true, allow_nil: true

  def self.model_name
    Voting.model_name
  end
end
