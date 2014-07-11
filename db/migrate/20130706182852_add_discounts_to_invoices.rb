class AddDiscountsToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :discounts, :integer, default: 0
  end
end
