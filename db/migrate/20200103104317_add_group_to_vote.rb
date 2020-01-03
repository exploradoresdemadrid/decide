class AddGroupToVote < ActiveRecord::Migration[6.0]
  def change
    add_reference :votes, :group, type: :uuid, foreign_key: true, null: true
  end
end
