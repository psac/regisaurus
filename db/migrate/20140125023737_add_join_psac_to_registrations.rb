class AddJoinPsacToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :join_psac, :boolean, default: false
  end
end
