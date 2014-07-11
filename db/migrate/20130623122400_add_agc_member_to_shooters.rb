class AddAgcMemberToShooters < ActiveRecord::Migration
  def change
    add_column :shooters, :agc_member, :boolean, default: false
  end
end
