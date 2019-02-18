class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string   :edi_source
      t.integer  :project_id
      t.string   :po_number
      t.datetime :issued_at
      t.decimal  :total_cost_in_dollars, precision: 16, scale: 2

      t.timestamps
    end
  end
end
