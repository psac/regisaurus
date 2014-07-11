class AddFieldsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :paid, :boolean, default: false
    add_column :invoices, :match_id, :integer
  end
end
