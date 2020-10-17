class AddFinishAtToVoting < ActiveRecord::Migration[6.0]
  def change
    add_column :votings, :finishes_at, :datetime
  end
end
