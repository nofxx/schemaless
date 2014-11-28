module Schemaless
  #
  # Do the twist!
  #
  module Worker

    class << self
      attr_accessor :tables

      def run!
        set_tables
        run_migrations
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

      def run_migrations
        tables.each do |table|
          table.work_fields
          table.work_indexes
        end
      end

      def generate_migrations
        migrations = tables.map(&:migration)
        migrations.each do |data|
          Rails::Generators.invoke('active_record:migration', data,
                                   behavior: :invoke,
                                   destination_root: Rails.root)
        end
      end

      def print_work(act, fields, table)
        fields = fields.map { |k, v| "#{k}:#{v}"  } if fields.is_a?(Hash)
        puts "#{act} '#{table}' | #{fields.join(', ')}"
      end

    end # self
  end # Worker
end # Schemaless
