# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can :manage, Group
      can :manage, Question
      can :manage, Voting
    else
      can %i[index show], Voting, id: Voting.published.pluck(:id)
    end
  end
end
