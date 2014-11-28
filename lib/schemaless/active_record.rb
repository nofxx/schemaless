require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      def self.schemaless_fields
        @schemaless_fields ||= []
      end
      def self.schemaless_indexes
        @schemaless_indexes ||= []
      end
    end

    #
    # Schemaless ActiveRecord attributes. Add
    #
    module ClassMethods
      #
      # Gets all fields in the model in the schamless_fields array.
      #
      def field(*params)
        config = params.extract_options!
        config.assert_valid_keys(:kind, :type, :default, :unique, :i18n)
        type = config[:type] || config[:kind]
        type ||= params.size > 1 ? params.pop : :string
        schemaless_fields << ::Schemaless::Field.new(self.table_name, params, type, config)
      end

      def belongs_to(*params)
        config = params.extract_options!
        schemaless_fields << ::Schemaless::Field.new(self.table_name, params, :belongs, config)
        super(*params)
      end

      def index(*params)
        config = params.extract_options!
        schemaless_indexes << ::Schemaless::Index.new(self.table_name, params, config)
      end
    end
  end # ActiveRecord
end # Schemaless
