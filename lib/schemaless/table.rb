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
      @name  = m.table_name
      @proposed = Schema.new(m.schemaless_fields, m.schemaless_indexes)
      set_current if exists?
    end

    def set_current
      @current = Schema.new(model.current_attributes, model.current_indexes)
    end

    def new_fields
      return proposed.fields unless current
      proposed.fields.reject { |f| current.fields.include?(f) }
    end

    def old_fields
      return [] unless exists?
      current.fields.reject { |f| proposed.fields.include?(f) }
    end

    def new_indexes
      return proposed.indexes unless current
      proposed.indexes.reject { |f| current.indexes.include?(f) }
    end

    def old_indexes
      return [] unless exists?
      current.indexes.reject { |f| proposed.indexes.include?(f) }
    end
    # changed = current.fields.select do |k, v|
    #   proposed.fields[k] && v != pr oposed.fields[k]
    # end
    #

    # Selects what needs to be done for fields.
    #
    def run!
      add_table! unless exists?
      (new_fields + new_indexes).each { |f| f.add!(self) }
      (old_fields + old_indexes).each { |f| f.del!(self) }
    end

    def migrate
      new_fields + new_indexes + old_fields + old_indexes
    end

    def migrate?
      migrate.flatten.any?
    end

    def exists?
      # Crazy, does not work: !table.table_exists?
      ::ActiveRecord::Base.connection.tables.include?(name)
    end

    #
    # Creates tables
    #
    def add_table!
      puts "Create table '#{name}' for #{model}"
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.create_table(name, *opts)
      set_current
    end

    def del_table!
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.drop_table(name)
      @current = nil
    end

    def migration
      "create_table #{name}, #{opts}"
    end
  end
end
