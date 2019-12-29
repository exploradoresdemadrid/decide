# frozen_string_literal: true

class VoteSubmission < ApplicationRecord
  belongs_to :voting
  belongs_to :group
end
