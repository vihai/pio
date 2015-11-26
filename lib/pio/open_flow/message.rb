require 'active_support/descendants_tracker'
require 'bindata'
require 'pio/open_flow/open_flow_header'
require 'pio/parse_error'

module Pio
  module OpenFlow
    # OpenFlow messages.
    class Message
      extend ActiveSupport::DescendantsTracker

      def self.read(raw_data)
        allocate.tap do |message|
          message.instance_variable_set(:@format,
                                        const_get(:Format).read(raw_data))
        end
      rescue BinData::ValidityError
        message_name = name.split('::')[1..-1].join(' ')
        raise Pio::ParseError, "Invalid #{message_name} message."
      end

      # rubocop:disable MethodLength
      # rubocop:disable AbcSize
      def self.method_missing(method, *args, &block)
        begin
          const_get(:Format).__send__ method, *args, &block
        rescue NameError
          const_set :Format, Class.new(BinData::Record)
          class_variable_set(:@@valid_options, [])
          retry
        end

        return if method == :endian || method == :virtual

        define_method(args.first) do
          @format.__send__ args.first
        end
        class_variable_set(:@@valid_options,
                           class_variable_get(:@@valid_options) + [args.first])
      end
      # rubocop:enable MethodLength
      # rubocop:enable AbcSize

      # rubocop:disable AbcSize
      # rubocop:disable MethodLength
      def self.open_flow_header(opts)
        module_eval do
          cattr_reader(:message_type, instance_reader: false) do
            opts.fetch(:message_type)
          end

          endian :big

          uint8 :ofp_version, value: opts.fetch(:version)
          virtual assert: -> { ofp_version == opts.fetch(:version) }
          uint8 :message_type, value: opts.fetch(:message_type)
          virtual assert: -> { message_type == opts.fetch(:message_type) }
          uint16 :message_length,
                 initial_value: opts[:message_length] || -> { 8 + body.length }
          transaction_id :transaction_id, initial_value: 0

          alias_method :xid, :transaction_id
        end
      end
      # rubocop:enable AbcSize
      # rubocop:enable MethodLength

      def initialize(user_options = {})
        validate_user_options user_options
        @format = self.class.const_get(:Format).new(parse_options(user_options))
      end

      def to_binary
        @format.to_binary_s
      end

      def method_missing(method, *args, &block)
        @format.__send__ method, *args, &block
      end

      private

      def validate_user_options(user_options)
        unknown_options =
          user_options.keys - self.class.class_variable_get(:@@valid_options)
        return if unknown_options.empty?
        fail "Unknown option: #{unknown_options.first}"
      end

      def parse_options(user_options)
        parsed_options = user_options.dup
        parsed_options[:transaction_id] = user_options[:transaction_id] || 0
        parsed_options[:body] = user_options[:body] || ''
        parsed_options
      end
    end
  end
end
