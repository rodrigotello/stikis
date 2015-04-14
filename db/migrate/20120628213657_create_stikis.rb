class CreateStikis < ActiveRecord::Migration
  def change
    create_table :stikis do |t|
      t.text :content
      t.integer :area
      t.decimal :positionx
      t.decimal :positiony
      t.integer :color
      t.integer :board_id
      t.integer :user_id

      t.timestamps
    end
  end
end
