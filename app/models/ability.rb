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
      cannot :index, Voting, status: :draft
    end
  end
end
