class RemoveDeviseJwt < ActiveRecord::Migration[6.0]
  def change
    drop_table :jwt_blacklist
  end
end
