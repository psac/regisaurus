class AddInvoiceIdToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :invoice_id, :integer
  end
end
