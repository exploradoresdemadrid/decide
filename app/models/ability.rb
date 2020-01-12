# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(_user)
    can :manage, :all
    cannot [:manage], Question do |question|
      !question.voting.draft?
    end
  end
end
