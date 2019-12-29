class AddUserToGroup < ActiveRecord::Migration[6.0]
  def change
    add_reference :groups, :user, index: { unique: true }, type: :uuid, foreign_key: true, unique: true
  end
end
