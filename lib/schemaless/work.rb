module Schemaless
  #
  # Do the twist!
  #
  class Work
    attr_accessor :schemas

    def initialize(_mode)
      set_schemas
    end

    def print_work(act, fields, table)
      fields = fields.map { |k, v| "#{k}:#{v}"  } if fields.is_a?(Hash)
      puts "#{act} '#{table}' | #{fields.join(', ')}"
    end

    #
    # Work!
    #
    def set_schemas # (models)
      ::Rails.application.eager_load!
      tables = ::ActiveRecord::Base.descendants
      fail 'No models...eager load off?' if tables.empty?
      tables.each do |table|
        next if table.to_s =~ /ActiveRecord::/
        table.reset_column_information
        @schemas << ::Schemaless::Schema.new(table)
      end
    end

    def generate_migrations
      migrations = schemas.map(&:migration)
      migrations.each do |data|
        Rails::Generators.invoke('active_record:migration', data,
                                 behavior: :invoke,
                                 destination_root: Rails.root)
      end
    end
  end
end
