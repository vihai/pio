# encoding: utf-8

require 'forwardable'
require 'pio/hello/format'

module Pio
  # OpenFlow 1.0 Hello message
  class Hello
    extend Forwardable

    def_delegators :@data, :version
    def_delegators :@data, :message_type
    def_delegators :@data, :message_length
    def_delegators :@data, :transaction_id
    def_delegator :@data, :transaction_id, :xid
    def_delegators :@data, :body
    def_delegator :@data, :to_binary_s, :to_binary

    # Parses +raw_data+ binary string into a Hello message object.
    #
    # @example
    #   Hello.read("\x01\x00\x00\b\x00\x00\x00\x00")
    # @return [Pio::Hello]
    def self.read(raw_data)
      hello = allocate
      hello.instance_variable_set :@data, Format.read(raw_data)
      hello
    end

    # Creates a Hello OpenFlow message.
    #
    # @overload initialize()
    #   @example
    #     Hello.new
    #
    # @overload initialize(transaction_id)
    #   @example
    #     Hello.new(123)
    #   @param [Number] transaction_id
    #     An unsigned 32-bit integer number associated with this
    #     message. If not specified, an auto-generated value is set.
    #
    # @overload initialize(user_options)
    #   @example
    #     Hello.new(transaction_id: 123)
    #     Hello.new(xid: 123)
    #   @param [Hash] user_options the options to create a message with.
    #   @option user_options [Number] :transaction_id
    #   @option user_options [Number] :xid an alias to transaction_id.
    def initialize(user_options = {})
      if user_options.respond_to?(:to_i)
        @options = { transaction_id: user_options.to_i }
      else
        @options = user_options.dup
        handle_user_options
      end
      @data = Format.new(@options)
    end

    private

    def handle_user_options
      @options[:transaction_id] ||= @options[:xid]
      @options[:transaction_id] = 0 unless @options[:transaction_id]
    end
  end
end
