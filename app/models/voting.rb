# frozen_string_literal: true

class Voting < ApplicationRecord
  enum status: %i[draft open finished]
end
