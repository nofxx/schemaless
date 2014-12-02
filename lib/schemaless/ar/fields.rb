require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  #
  # Extend ActiveRecord for #field
  #
  module Fields
    extend ActiveSupport::Concern

    # Schemaless ActiveRecord fields
    module ClassMethods
      AR_OPTS = ::Schemaless::Field::VALID_OPTS - [:index, :type]

      def schemaless_fields
        @schemaless_fields ||= []
      end

      #
      # field(*)
      #
      # Gets all fields in the model in the schamless_fields array.
      #
      #     field :name                # Defaults String
      #     field :cylinders, Integer  # Use Class or :symbols
      #     field :type, index: true, default: nil, limit: 5
      #
      #
      def field(*params)
        config = params.extract_options!
        config.assert_valid_keys(*::Schemaless::Field::VALID_OPTS)
        type = config.delete(:type)
        type ||= params.size > 1 ? params.pop : :string # TBD
        name = params.join
        schemaless_fields <<
          ::Schemaless::Field.new(name, type, config)
      end

      #
      # Create the belongs_to foreign keys
      #
      def belongs_to(*params)
        config = params.extract_options!
        name = "#{params.join}_id"
        schemaless_fields <<
          ::Schemaless::Field.new(name, :integer, config)
        super(*params)
      end

      #
      # Helper for timestamps
      #
      def timestamps(*params)
        config = params.extract_options!
        type = config[:type] || :timestamp
        schemaless_fields << ::Schemaless::Field.new(:created_at, type, null: false)
        schemaless_fields << ::Schemaless::Field.new(:updated_at, type, null: true)
        return unless config[:paranoid]
        schemaless_fields << ::Schemaless::Field.new(:deleted_at, type, null: true)
      end

      #
      # Get all fields in a schemaless way
      #
      def current_attributes
        columns_hash.map do |k, v|
          next if v.primary
          opts = AR_OPTS.reduce({}) do |a, e|
            v.send(e) ? a.merge(e => v.send(e)) : a
          end
          ::Schemaless::Field.new(k, v.type, opts)
        end.reject!(&:nil?)
      end
    end
  end
end
