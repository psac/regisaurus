class AddFieldsToShooters < ActiveRecord::Migration
  def change
    add_column :shooters, :lady, :boolean
    add_column :shooters, :military, :boolean
    add_column :shooters, :law, :boolean
  end
end
