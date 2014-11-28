module Schemaless
  # Appreciate the irony

  class Table
    attr_accessor :name, :current, :proposed, :model, :migration, :opts
    Schema = Struct.new(:fields, :indexes)

    def initialize(model)
      @model = model
      @name = model.name
      @current = from_ar(model)
      @proposed = from_rb(model)
      # Crazy, does not work: !table.table_exists?
      add_table! unless ::ActiveRecord::Base.connection.tables.include?(name)
    end

    def from_rb(m)
      Schema.new(m.schemaless_fields, m.schemaless_indexes)
    end

    def from_ar(m)
      fields = m.columns_hash.map do |k, v|
        next if v.primary # || k =~ /.*_id$/
        opts = { limit: v.limit, precision: v.precision, scale: v.scale,
                 null: v.null, default: v.default }
        ::Schemaless::Field.new(m.table_name, k, v.type, opts)
      end.reject!(&:nil?)
      indexes = ::ActiveRecord::Base.connection.indexes(m).map do|i|
        ::Schemaless::Index.new(m.table_name, i.name, i)
      end
      Schema.new(fields, indexes)
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
    #   proposed.fields[k] && v != proposed.fields[k]
    # end
    #
    # Selects what needs to be done for fields.
    #
    def run!
      new_fields.each(&:add_field!)
      old_fields.each(&:del_field!)
      new_indexes.each(&:add_index!)
      old_indexes.each(&:del_index!)
    end

    def migrate
      (new_fields + new_indexes).map { |f| f.migration(:add) } +
        (old_fields + old_indexes).map { |f| f.migration(:remove) }
    end

    #
    # Creates tables
    #
    def add_table!
      puts "Create table '#{name}' for #{model}"
      return if Schemaless.sandbox
      if Schemaless.migrate
        ::ActiveRecord::Migration.send(:create_table, name, *opts)
      else
        "create_table #{name}, #{opts}"
      end
    end

    def del_table!
      ::ActiveRecord::Migration.drop_table(:users)
    end
  end
end
