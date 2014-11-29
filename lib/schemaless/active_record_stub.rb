require 'active_support/concern'

module Schemaless
  #
  # Extend ActiveRecord for live and migrate way
  #
  module ActiveRecord
    extend ActiveSupport::Concern

    #
    # Schemaless ActiveRecord attributes. Add
    #
    module ClassMethods
      #
      # Gets all fields in the model in the schamless_fields array.
      #
      def field(*)
      end

      def index(*)
      end
    end
  end # ActiveRecord
end # Schemaless
