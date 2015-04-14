class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :user_id
      t.text :name
      t.boolean :main_board, :default => false

      t.timestamps
    end
  end
end
