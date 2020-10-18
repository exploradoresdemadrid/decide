# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    current_org_id = user.organization_id

    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can :manage, Group, organization_id: current_org_id
      can :manage, Question, voting: { organization_id: current_org_id }
      can :manage, Voting, organization_id: current_org_id
      can :manage, Body, organization_id: current_org_id
    else
      can %i[index show vote], Voting, id: Voting.published.pluck(:id), organization_id: current_org_id
    end
  end
end
