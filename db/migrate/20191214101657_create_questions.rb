class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.references :voting, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
