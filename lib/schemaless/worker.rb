module Schemaless
  #
  # Do the twist!
  #
  module Worker
    # Module class methods
    class << self
      attr_accessor :tables

      def run!
        set_tables
        tables.each(&:run!)
        ::ActiveRecord::Base.descendants.each(&:reset_column_information)
      end

      def generate!
        set_tables
        generate_migrations
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

      def generate_migrations
        migrations = tables.map(&:migrate).join("\n")
        puts migrations
        # migrations.each do |data|
        #   ::Rails::Generators.invoke('active_record:migration', data,
        #                            behavior: :invoke,
        #                            destination_root: Rails.root)
        # end
      end
    end # self
  end # Worker
end # Schemaless
