require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  #
  # Extend ActiveRecord for live and migrate way
  #
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
        name = params.join
        schemaless_fields <<
          ::Schemaless::Field.new(table_name, name, type, config)
      end

      def index(*params)
        config = params.extract_options!
        name = params.join
        schemaless_indexes <<
          ::Schemaless::Index.new(table_name, name, config)
      end

      def belongs_to(*params)
        config = params.extract_options!
        name = "#{params.join}_id"
        schemaless_fields <<
          ::Schemaless::Field.new(table_name, name, :belongs, config)
        super(*params)
      end

      def current_attributes
        columns_hash.map do |k, v|
          next if v.primary # || k =~ /.*_id$/
          opts = { limit: v.limit, precision: v.precision, scale: v.scale,
                   null: v.null, default: v.default }
          ::Schemaless::Field.new(table_name, k, v.type, opts)
        end.reject!(&:nil?)
      end

      def current_indexes
        ::ActiveRecord::Base.connection.indexes(self).map do|i|
          ::Schemaless::Index.new(table_name, i.name, i)
        end
      end
    end
  end # ActiveRecord
end # Schemaless
