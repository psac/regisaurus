class AddFieldsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :title, :string
    add_column :matches, :club, :string
    add_column :matches, :club_id, :string
  end
end
