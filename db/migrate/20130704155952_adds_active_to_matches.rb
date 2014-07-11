class AddsActiveToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :active, :boolean, default: false
  end
end
