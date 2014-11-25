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
    # Schemaless ActiveRecord attributes. Add
    #
    module ClassMethods
      # def inherited(subclass)
      #   puts "Ive been inherited by #{subclass}"
      #   subclass.cattr_accessor :schemaless_fields #, :instance_reader => false
      #   subclass.schemaless_fields ||= []
      #   super
      # end
      # def schemaless_fields
      #   @schemaless_fields ||= []
      #   #subclass.cattr_accessor :schemaless_fields do []; end #, instance_reader: false
      # end
      # Specifies that values of the given attributes should be returned
      # as symbols. The table column should be created of type string.

      def field(*attr_names)
        config = attr_names.extract_options!
        config.assert_valid_keys(:kind, :type, :default, :i18n)
        type = Schemaless.map_field(config[:type] || config[:kind]) || :string

        attr_names.each do |attr_name|
          schemaless_fields.merge!(attr_name.to_s => type)
        end
      end

      # # String becomes symbol, booleans string and nil nil.
      # def schemaless_attribute(value)
      #   case value
      #   when String
      #     value.presence.try(:to_sym)
      #   when Symbol, TrueClass, FalseClass, Numeric
      #     value
      #   else
      #     nil
      #   end
      # end

      # def i18n_translation_for(attr_name, attr_value)
      #   I18n.translate("activerecord.schemalesss.#{model_name.to_s.underscore}.#{attr_name}.#{attr_value}")
      # end
    end
  end # ActiveRecord
end # Schemaless
