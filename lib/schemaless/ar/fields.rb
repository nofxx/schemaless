require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  #
  # Extend ActiveRecord for #field
  #
  module Fields
    extend ActiveSupport::Concern

    included do
      def self.schemaless_fields
        @schemaless_fields ||= []
      end
    end

    # Schemaless ActiveRecord fields
    module ClassMethods
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
        config.assert_valid_keys(:kind, :type, :default, :unique, :i18n)
        type = config.delete(:type) || config.delete(:kind)
        type ||= params.size > 1 ? params.pop : :string
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
          ::Schemaless::Field.new(name, :belongs, config)
        super(*params)
      end

      #
      # Get all fields in a schemaless way
      #
      def current_attributes
        columns_hash.map do |k, v|
          next if v.primary # || k =~ /.*_id$/
          opts = { limit: v.limit, precision: v.precision, scale: v.scale,
                   null: v.null, default: v.default }
          ::Schemaless::Field.new(k, v.type, opts)
        end.reject!(&:nil?)
      end
    end
  end
end
