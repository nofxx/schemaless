module Schemaless
  # Appreciate the irony
  #
  # A Table, how much information! How much entropy!
  #
  class Table
    attr_accessor :name, :current, :proposed, :fields, :indexes, :model, :opts

    Schema = Struct.new(:fields, :indexes)

    Diffs  = Struct.new(:proposed, :current) do
      def add
        return proposed unless current
        @add ||= proposed.reject { |o| current.include?(o) }
      end

      def remove
        return [] unless current
        @remove ||= current.reject { |o| proposed.include?(o) }
      end

      def change
        return [] unless current
        @change ||= \
        (proposed - add - remove).select do |f|
          other = current.select { |c| c.name == f.name }.first
          f.opts.select { |k, v| opts.opts[k] != v }.any? # != other.opts
        end
      end

      def migrate?
        (add + remove + change).any?
      end
    end

    def initialize(m)
      @model = m
      @name  = m.table_name
      @proposed = Schema.new(m.schemaless_fields, m.schemaless_indexes)
      set_current if exists?
      @fields  = Diffs.new(@proposed.fields, @current.try(:fields))
      @indexes = Diffs.new(@proposed.indexes, @current.try(:indexes))
    end

    def set_current
      @current = Schema.new(model.current_attributes, model.current_indexes)
    end

    #
    # Selects what needs to be done for fields.
    #
    def run!
      add_table! unless exists?
      # Order matter here
      (indexes.change + fields.change).each { |f| f.change!(self) }
      (indexes.remove + fields.remove).each { |f| f.del!(self) }
      (fields.add + indexes.add).each { |f| f.add!(self) }
    end

    def migrate?
      fields.migrate? || indexes.migrate?
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
  end
end
