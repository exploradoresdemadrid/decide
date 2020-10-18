class AddBodyToVoting < ActiveRecord::Migration[6.0]
  def change
    add_reference :votings, :body, type: :uuid, foreign_key: true
  end
end
