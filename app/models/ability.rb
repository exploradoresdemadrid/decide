# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(_user)
    can :manage, :all
    cannot :edit, Voting do |voting|
      !voting.draft?
    end
  end
end
