class AddOrganizationIdToVotingAndUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :organization, type: :uuid, foreign_key: true
    add_reference :votings, :organization, type: :uuid, foreign_key: true
    add_reference :groups, :organization, type: :uuid, foreign_key: true
  end
end
