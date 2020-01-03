class AddPrivateToVotings < ActiveRecord::Migration[6.0]
  def change
    add_column :votings, :secret, :boolean, null: false, default: false
  end
end
