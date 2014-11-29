require 'active_support/concern'

module Schemaless
  # Stubs for production mode
  module Stubs
    extend ActiveSupport::Concern

    # Schemaless ActiveRecord Stub
    module ClassMethods
      def field(*)     end

      def index(*)     end
    end
  end # Stubs
end # Schemaless
