class AddFieldsToMultiselectVoting < ActiveRecord::Migration[6.0]
  def change
    add_column :votings, :max_options, :integer
  end
end
