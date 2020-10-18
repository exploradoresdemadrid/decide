class CreateBodies < ActiveRecord::Migration[6.0]
  def change
    create_table :bodies, id: :uuid do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.integer :default_votes

      t.timestamps
    end
  end
end
