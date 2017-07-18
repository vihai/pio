# frozen_string_literal: true

require 'bindata'
#require 'pio/mac'
#require 'pio/monkey_patch/integer'
#require 'pio/monkey_patch/uint'
require 'ynetaddr'

module Pio
  module Type
    # MAC address
    class MacAddress < BinData::Primitive
      string :data, read_length: 6

      def set(value)
        self.data = Net::MacAddr.new(value || '0000.0000.0000').to_binary
      end

      def get
        (data && data.num_bytes > 0) ? Net::MacAddr.new(binary: data) : nil
      end

      def to_bytes
        data
      end

      def inspect
        %("#{get}")
      end
    end
  end
end
