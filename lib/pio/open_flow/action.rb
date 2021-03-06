# frozen_string_literal: true

require 'active_support/descendants_tracker'
require 'bindata'

module Pio
  module OpenFlow
    # OpenFlow actions.
    class Action
      extend ActiveSupport::DescendantsTracker

      def self.action_header(options)
        module_eval do
          endian :big

          uint16 :action_type, value: options.fetch(:action_type)
          uint16 :action_length, value: options.fetch(:action_length)
        end
      end

      def self.read(raw_data)
        action = allocate
        action.instance_variable_set :@format, const_get(:Format).read(raw_data)
        action
      end

      def self.method_missing(method, *args, &block)
        begin
          const_get(:Format).__send__ method, *args, &block
        rescue NameError
          const_set :Format, Class.new(BinData::Record)
          retry
        end
        return if method == :endian || method == :virtual
        define_method(args.first) { @format.__send__ args.first }
      end

      def initialize(user_options)
        @format = self.class.const_get(:Format).new(user_options)
      end

      def to_binary
        @format.to_binary_s
      end
    end
  end
end
