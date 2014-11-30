module Schemaless
  # Appreciate the irony
  #
  # A Table, how much information! How much entropy!
  #
  class Table
    attr_accessor :name, :current, :proposed, :model, :migration, :opts
    Schema = Struct.new(:fields, :indexes)

    def initialize(m)
      @model = m
      @name = m.table_name
      @current  = Schema.new(m.current_attributes, m.current_indexes)
      @proposed = Schema.new(m.schemaless_fields, m.schemaless_indexes)
    end

    def new_fields
      proposed.fields.reject { |f| current.fields.include?(f) }
    end

    def old_fields
      current.fields.reject { |f| proposed.fields.include?(f) }
    end

    def new_indexes
      proposed.indexes.reject { |f| current.indexes.include?(f) }
    end

    def old_indexes
      current.indexes.reject { |f| proposed.indexes.include?(f) }
    end
    # changed = current.fields.select do |k, v|
    #   proposed.fields[k] && v != pr oposed.fields[k]
    # end
    #
    # Selects what needs to be done for fields.
    #
    def run!
      # Crazy, does not work: !table.table_exists?
      add_table! unless exists?

      (new_fields + new_indexes).each { |f| f.add!(self) }
      (old_fields + old_indexes).each { |f| f.add!(self) }
    end

    def migrate
      new_fields + new_indexes + old_fields + old_indexes
    end

    def migrate?
      migrate.flatten.any?
    end

    def exists?
      ::ActiveRecord::Base.connection.tables.include?(name)
    end

    #
    # Creates tables
    #
    def add_table!
      puts "Create table '#{name}' for #{model}"
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.create_table(name, *opts)
    end

    def del_table!
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.drop_table(name)
    end

    def migration
      "create_table #{name}, #{opts}"
    end
  end
end
