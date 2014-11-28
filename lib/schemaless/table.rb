module Schemaless
  #
  # DB Table
  #
  class Table
    attr_accessor :name, :fields, :indexes
                  # :name, :migration, :added, :removed, :changed

    def initialize(name, fields = [], indexes = [])
      @name = name
      @fields = fields
      @indexes = indexes
              # Crazy, does not work: !table.table_exists?
             unless ::ActiveRecord::Base.connection.tables.include?(table)
          add_table(table)
          e.reset_column_information
             end
    end

    def self.from_rb(t)
      new(t.table_name, t.schemaless_fields, t.schemaless_indexes)
    end

    def self.from_db(t)
      name = t.table_name
      fields = e.columns_hash
      #          .each do |k, v|
      #     next if v.primary # || k =~ /.*_id$/
      #     attributes.merge!(k => v.type)
      # end
      indexes = ::ActiveRecord::Base.connection.indexes(table).map(&:name)
      new(name, fields, indexes)
    end


    #
    # Creates tables
    #
    def self.add_table(table, *opts)
      puts "Create table '#{table}' #{opts}"
      puts '-' * (table.to_s.size + 15)
      return if Schemaless.sandbox
      if Schemaless.migrate
        ::ActiveRecord::Migration.send(:create_table, table, *opts)
      else
        "create_table #{table}, #{opts}"
      end
    end

    def del_table
      ::ActiveRecord::Migration.drop_table(:users)
    end
  end
end
