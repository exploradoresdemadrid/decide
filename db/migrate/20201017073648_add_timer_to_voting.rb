class AddTimerToVoting < ActiveRecord::Migration[6.0]
  def change
    add_column :votings, :timeout_in_seconds, :integer
  end
end
