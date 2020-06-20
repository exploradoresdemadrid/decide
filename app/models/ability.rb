# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    cannot [:manage], Question do |question|
      !question.voting.draft?
    end

    if user.superadmin?
      can :manage, :all
    elsif user.admin?
    else
      cannot :index, Group
      cannot :index, Question
      cannot %i[edit destroy create], Voting
      cannot :index, Voting, status: :draft
    end
  end
end
