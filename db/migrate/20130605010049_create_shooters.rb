class CreateShooters < ActiveRecord::Migration
  def change
    create_table :shooters do |t|
      t.string :first_name
      t.string :last_name
      t.string :uspsa_number
      t.string :gender
      t.string :age
      t.string :member
      t.string :agc_number

      t.timestamps
    end
  end
end
