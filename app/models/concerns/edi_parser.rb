require 'date'

module EdiParser
  include ActiveSupport::Concern

  class Parsedi
    attr_accessor :segments

    def initialize(edi_string, segment_delimiter = '~', element_delimiter = '*')
      segment_strings = edi_string.split(segment_delimiter)
      segment_array   = []

      segment_strings.each do |segment_string|
        segment = EdiSegment.new(self, segment_string, element_delimiter)

        segment_array.push(segment)
      end

      @segments = segment_array
    end

    def find_segments(segment_code)
      found_segments = []

      segments.each do |segment|
        if segment.segment_identifier.downcase == segment_code.downcase
          found_segments.push(segment)
        end
      end

      found_segments
    end

    def find_segment(segment_code)
      find_segments(segment_code).first
    end

    def invoice_issued_at
      datetime_string = find_segment('BIG').elements.first

      string_to_datetime(datetime_string)
    end

    def project_id
      find_segment('BIG').elements.last.split("-").last
    end

    def purchase_order_number
      find_segment('BIG').elements.fourth
    end

    def total_cost_in_dollars
      find_segment('TDS').elements.first.to_i / 100
    end

    private

    def string_to_datetime(string)
      year  = string.first(4).to_i
      month = string[5..6].to_i
      day   = string.last(2).to_i

      DateTime.new(year, day, month)
    end
  end

  class EdiSegment
    attr_accessor :elements
    attr_accessor :parent
    attr_accessor :segment_identifier

    def initialize(parent, string, element_delimiter)
      element_strings     = string.split(element_delimiter)
      @parent             = parent
      @segment_identifier = element_strings.shift.strip

      element_array = []

      element_strings.each do |element_string|
        element_array.push(element_string)
      end

      @elements = element_array
    end
  end
end
