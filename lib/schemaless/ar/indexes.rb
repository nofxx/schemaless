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
        name = config.delete(:name)
        schemaless_indexes <<
          ::Schemaless::Index.new(params, name, config)
      end

      #
      # Get all indexes in a schemaless way
      #
      def current_indexes
        ::ActiveRecord::Base.connection.indexes(table_name).map do |i|
          opts = ::Schemaless::Index::VALID_OPTS.reduce({}) do |a, e|
            i.send(e) ? a.merge(e => i.send(e)) : a
          end
          ::Schemaless::Index.new(i.columns, i.name, opts)
        end
      end
    end
  end # ActiveRecord
end # Schemaless
