class AddWaiverToShooters < ActiveRecord::Migration
  def change
    add_column :shooters, :waiver, :date
  end
end
