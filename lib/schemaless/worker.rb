module Schemaless
  #
  # Do the twist!
  #
  module Worker
    # Module class methods
    class << self
      attr_accessor :tables

      #
      # Run Schemaless live mode
      #
      def run!
        set_tables
        tables.each(&:run!)
        ::ActiveRecord::Base.descendants.each(&:reset_column_information)
      end

      #
      # Run Schemaless migrations
      #
      # ::Rails::Generators
      #   .invoke('schemaless:migration', data, file_name: 'fu',
      #           behavior: :invoke, destination_root: Rails.root)
      def generate!
        set_tables
        tables.each do |table|
          next unless table.migrate?
          Schemaless::MigrationGenerator.new([table]).invoke_all
        end
      end

      #
      # Work!
      #
      def set_tables # (models)
        @tables = []
        ::Rails.application.eager_load!
        tables = ::ActiveRecord::Base.descendants
        fail 'No models...eager load off?' if tables.empty?
        tables.each do |table|
          next if table.to_s =~ /ActiveRecord::/
          table.reset_column_information
          @tables << ::Schemaless::Table.new(table)
        end
      end
    end # self
  end # Worker
end # Schemaless
