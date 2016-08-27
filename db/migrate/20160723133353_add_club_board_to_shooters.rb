class AddClubBoardToShooters < ActiveRecord::Migration
  def change
    add_column :shooters, :club_board, :string
  end
end
