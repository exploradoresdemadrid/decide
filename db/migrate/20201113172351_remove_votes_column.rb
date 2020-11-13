class RemoveVotesColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :groups, :available_votes, :integer, null: false, default: 1
  end
end
