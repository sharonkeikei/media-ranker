class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user , index: true
      t.references :work , index: true
      t.boolean :upvote
      # true for upvote
      # false for downvote

      t.timestamps
    end
  end
end
