require 'active_support/concern'
require 'active_support/core_ext/hash/keys'

module Schemaless
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      def self.schemaless_fields
        @schemaless_fields ||= {}
      end
    end
    #
    # Schemaless ActiveRecord attributes. Add
    #
    module ClassMethods
      #
      # Gets all fields in the model in the schamless_fields array.
      #
      def field(*attr_names)
        config = attr_names.extract_options!
        config.assert_valid_keys(:kind, :type, :default, :i18n)
        type = Schemaless.map_field(config[:type] || config[:kind]) || :string

        attr_names.each do |attr_name|
          schemaless_fields.merge!(attr_name.to_s => type)
        end
      end
    end
  end # ActiveRecord
end # Schemaless
