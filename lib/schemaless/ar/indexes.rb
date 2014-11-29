require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  #
  # Extend ActiveRecord for #index
  #
  module Indexes
    extend ActiveSupport::Concern

    included do
      def self.schemaless_indexes
        @schemaless_indexes ||= []
      end
    end

    # Schemaless ActiveRecord indexes
    module ClassMethods
      #
      # index(*)
      #
      #     index :name
      #     index [:one, :other]
      #     index :name, unique: true
      #
      #
      def index(*params)
        config = params.extract_options!
        name = params.join
        schemaless_indexes <<
          ::Schemaless::Index.new(table_name, name, config)
      end

      #
      # Get all indexes in a schemaless way
      #
      def current_indexes
        ::ActiveRecord::Base.connection.indexes(self).map do|i|
          ::Schemaless::Index.new(table_name, i.name, i)
        end
      end
    end
  end # ActiveRecord
end # Schemaless
