# frozen_string_literal: true

class CreateVoteSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :vote_submissions, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :voting, null: false, foreign_key: true, type: :uuid
      t.integer :votes_submitted
    end

    add_index :vote_submissions, %i[group_id voting_id], unique: true
  end
end
