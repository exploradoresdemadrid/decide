# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
    cannot [:manage], Question do |question|
      !question.voting.draft?
    end

    if user.admin?
      cannot :vote, Voting
    else
      cannot :index, Group
      cannot :index, Question
      cannot %i[edit destroy create], Voting
    end
  end
end
