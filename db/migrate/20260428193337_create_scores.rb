class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :time_seconds, null: false
      t.integer :moves, null: false
      t.string :game_type, null: false, default: '15puzzle'

      t.timestamps
    end

    add_index :scores, [:game_type, :time_seconds]
  end
end