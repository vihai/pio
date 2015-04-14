require 'English'
require 'bindata'
require 'pio/open_flow'
require 'pio/type/ip_address'
require 'pio/type/mac_address'

module Pio
  # Fields to match against flows
  class Match
    # Flow wildcards
    class Wildcards < BinData::Primitive
      BITS = {
        in_port: 1 << 0,
        dl_vlan: 1 << 1,
        eth_src_addr: 1 << 2,
        eth_dst_addr: 1 << 3,
        dl_type: 1 << 4,
        nw_proto: 1 << 5,
        tp_src: 1 << 6,
        tp_dst: 1 << 7,
        nw_src: 0,
        nw_src0: 1 << 8,
        nw_src1: 1 << 9,
        nw_src2: 1 << 10,
        nw_src3: 1 << 11,
        nw_src4: 1 << 12,
        nw_src_all: 1 << 13,
        nw_dst: 0,
        nw_dst0: 1 << 14,
        nw_dst1: 1 << 15,
        nw_dst2: 1 << 16,
        nw_dst3: 1 << 17,
        nw_dst4: 1 << 18,
        nw_dst_all: 1 << 19,
        dl_vlan_pcp: 1 << 20,
        nw_tos: 1 << 21
      }
      NW_FLAGS = [:nw_src, :nw_dst]
      FLAGS = BITS.keys.select { |each| !(/^nw_(src|dst)/=~ each) }

      endian :big

      uint32 :flags

      # This method smells of :reek:FeatureEnvy
      def get
        BITS.each_with_object(Hash.new(0)) do |(key, bit), memo|
          next if flags & bit == 0
          if /(nw_src|nw_dst)(\d)/=~ key
            memo[$LAST_MATCH_INFO[1].intern] |= 1 << $LAST_MATCH_INFO[2].to_i
          else
            memo[key] = true
          end
        end
      end

      def set(params)
        self.flags = params.inject(0) do |memo, (key, val)|
          memo | case key
                 when :nw_src, :nw_dst
                   (params.fetch(key) & 31) << (key == :nw_src ? 8 : 14)
                 else
                   val ? BITS.fetch(key) : 0
                 end
        end
      end

      def nw_src
        get.fetch(:nw_src)
      rescue KeyError
        0
      end

      def nw_dst
        get.fetch(:nw_dst)
      rescue KeyError
        0
      end
    end

    # IP address
    class MatchIpAddress < BinData::Primitive
      default_parameter bitcount: 0

      array :octets, type: :uint8, initial_length: 4

      def set(value)
        self.octets = IPv4Address.new(value).to_a
      end

      def get
        ipaddr = octets.map { |each| format('%d', each) }.join('.')
        prefixlen = 32 - eval_parameter(:bitcount)
        IPv4Address.new(ipaddr + "/#{prefixlen}")
      end

      def ==(other)
        get == other
      end
    end

    # ofp_match format
    class MatchFormat < BinData::Record
      endian :big

      wildcards :wildcards
      uint16 :in_port
      mac_address :eth_src_addr
      mac_address :eth_dst_addr
      uint16 :dl_vlan
      uint8 :dl_vlan_pcp
      uint8 :padding1
      hide :padding1
      uint16 :dl_type
      uint8 :nw_tos
      uint8 :nw_proto
      uint16 :padding2
      hide :padding2
      match_ip_address :nw_src, bitcount: -> { wildcards.nw_src }
      match_ip_address :nw_dst, bitcount: -> { wildcards.nw_dst }
      uint16 :tp_src
      uint16 :tp_dst
    end

    def self.read(binary)
      MatchFormat.read binary
    end

    # rubocop:disable MethodLength
    # This method smells of :reek:FeatureEnvy
    # This method smells of :reek:DuplicateMethodCall
    def initialize(user_options)
      flags = Wildcards::FLAGS.each_with_object({}) do |each, memo|
        memo[each] = true unless user_options.key?(each)
      end
      Wildcards::NW_FLAGS.each_with_object(flags) do |each, memo|
        if user_options.key?(each)
          memo[each] = 32 - IPv4Address.new(user_options[each]).prefixlen
        else
          memo["#{each}_all".intern] = true
        end
      end
      @format = MatchFormat.new({ wildcards: flags }.merge user_options)
    end
    # rubocop:enable MethodLength

    def to_binary
      @format.to_binary_s
    end

    def ==(other)
      return false unless other
      to_binary == other.to_binary
    end

    def method_missing(method, *args, &block)
      @format.__send__ method, *args, &block
    end
  end
end
