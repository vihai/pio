# frozen_string_literal: true

require 'bindata'

module Pio
  class Lldp
    # TLV value field of system name TLV
    class SystemNameValue < BinData::Record
      endian :big

      string :system_name
    end
  end
end
