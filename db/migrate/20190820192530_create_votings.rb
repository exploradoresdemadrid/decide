class CreateVotings < ActiveRecord::Migration[6.0]
  def change
    create_table :votings, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
