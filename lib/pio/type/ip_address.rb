# frozen_string_literal: true

require 'bindata'
require 'ynetaddr'

module Pio
  module Type

    # IP address
    class IpAddress < BinData::Primitive
      string :octets, read_length: 4

      def set(value)
        self.octets = Net::IPv4Addr.new(value || '0.0.0.0').to_binary
      end

      def get
        octets ? Net::IPv4Addr.new(binary: octets) : nil
      end

      def >>(other)
        get.to_i >> other
      end

      def &(other)
        get.to_i & other
      end

      def ==(other)
        get == other
      end

      def to_bytes
        octets
      end

      def inspect
        %("#{get}")
      end
    end
  end
end
