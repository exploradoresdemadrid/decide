class AddStiToVotings < ActiveRecord::Migration[6.0]
  def change
    add_column :votings, :type, :string, null: false, default: 'SimpleVoting'
  end
end
