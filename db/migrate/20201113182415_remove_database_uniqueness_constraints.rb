class RemoveDatabaseUniquenessConstraints < ActiveRecord::Migration[6.0]
  def change
    remove_index :groups, :name
  end
end
