json.extract! invoice, :id, :edi_source, :project_id, :po_number, :issued_at, :total_cost_in_dollars, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
