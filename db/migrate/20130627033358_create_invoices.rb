class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :cash, default: 0
      t.integer :check, default: 0
      t.integer :points, default: 0

      t.timestamps
    end
  end
end
