class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :shooter_id
      t.integer :match_id
      t.integer :fee
      t.integer :paid
      t.text :notes
      t.string :division
      t.string :power_factor
      t.integer :squad

      t.timestamps
    end
  end
end
