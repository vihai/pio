# frozen_string_literal: true

require 'ynetaddr'

module Pio
  class Dhcp
    # DHCP Common Options.
    module CommonOptions
      BOOTPC = 68
      BOOTPS = 67
      QUAD_ZERO_IP_ADDRESS = Net::IPv4Addr.new(0)
      BROADCAST_MAC_ADDRESS = Net::MacAddr.new(0xffffffffffff)
      BROADCAST_IP_ADDRESS = Net::IPv4Addr.new(0xffffffff)

      def dhcp_data
        Dhcp::DhcpField.new(dhcp_field_values)
      end

      def type
        @options[:type]
      end

      def source_mac
        Net::MacAddr.new(@options[:source_mac])
      end

      def destination_mac
        Net::MacAddr.new(@options[:destination_mac] || BROADCAST_MAC_ADDRESS)
      end

      def source_ip_address
        Net::IPv4Addr.new(@options[:source_ip_address])
      end

      def destination_ip_address
        Net::IPv4Addr.new(@options[:destination_ip_address])
      end

      def server_identifier
        Net::IPv4Addr.new(
          @options[:server_identifier] || source_ip_address
        )
      end

      def subnet_mask
        subnet = @options[:subnet_mask]
        Net::IPv4Addr.new(subnet) if subnet
      end

      def transaction_id
        @options[:transaction_id]
      end

      def renewal_time_value
        @options[:renewal_time_value]
      end

      def rebinding_time_value
        @options[:rebinding_time_value]
      end

      def ip_address_lease_time
        @options[:ip_address_lease_time]
      end

      def requested_ip_address
        Net::IPv4Addr.new(
          @options[:requested_ip_address] || QUAD_ZERO_IP_ADDRESS
        )
      end
    end
  end
end
