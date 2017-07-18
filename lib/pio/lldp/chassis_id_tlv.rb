# frozen_string_literal: true

require 'bindata'

module Pio
  # LLDP frame parser and generator.
  class Lldp
    # Chassis ID TLV
    class ChassisIdTlv < BinData::Record
      endian :big

      bit7 :tlv_type, value: 1
      bit9(:tlv_info_length,
           value: -> { subtype.num_bytes + chassis_id.length })
      uint8 :subtype, initial_value: 7
      string(:chassis_id,
             read_length: -> { tlv_info_length - subtype.num_bytes })

    end
  end
end
