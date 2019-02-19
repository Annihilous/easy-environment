require 'date'

module PellaEdiParser
  include ActiveSupport::Concern

  class PellaInvoice
    attr_reader :total_cost_in_dollars
    attr_reader :invoice_issued_at
    attr_reader :purchase_order_id
    attr_reader :project_id

    def initialize(edi_string)
      @edi_content = edi_string

      edi_hash = {}
      
      edi_string.split("~").each do |edi_segment|
        segment_array = edi_segment.split("*")
        key           = segment_array.shift.strip
        value         = segment_array

        edi_hash[key] = value
      end

      @total_cost_in_dollars = edi_hash["TDS"].first.to_i / 100
      @invoice_issued_at     = string_to_datetime(edi_hash["BIG"].first)
      @purchase_order_id     = edi_hash["BIG"].second
      @project_id            = edi_hash["BIG"].last.split("-").last
    end

    def string_to_datetime(string)
      year  = string.first(4).to_i
      month = string[5..6].to_i
      day   = string.last(2).to_i

      DateTime.new(year, month, day)
    end
  end
end
