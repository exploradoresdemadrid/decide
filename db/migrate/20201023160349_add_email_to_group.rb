class AddEmailToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :email, :string
  end
end
