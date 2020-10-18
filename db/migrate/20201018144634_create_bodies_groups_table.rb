class CreateBodiesGroupsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :bodies_groups, id: :uuid do |t|
      t.references :body, null: false, foreign_key: true, type: :uuid
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.integer :votes
    end
  end
end
