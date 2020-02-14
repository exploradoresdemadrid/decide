# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
    cannot [:manage], Question do |question|
      !question.voting.draft?
    end

    unless user.admin?
      cannot :index, Group
    end
  end
end
