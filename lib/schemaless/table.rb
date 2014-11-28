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
      add! unless ::ActiveRecord::Base.connection.tables.include?(name)
    end

    def from_rb(m)
      Schema.new(m.schemaless_fields, m.schemaless_indexes)
    end

    def from_ar(m)
      fields = m.columns_hash.map do |k, v|
        next if v.primary # || k =~ /.*_id$/
        opts = { limit: v.limit, precision: v.precision, scale: v.scale,
                 null: v.null, default: v.default }
        ::Schemaless::Field.new(k, v.type, opts)
      end.reject!(&:nil?)
      indexes = ::ActiveRecord::Base.connection.indexes(m).map do|i|
        ::Schemaless::Index.new(i.name, i)
      end
      Schema.new(fields, indexes)
    end

    #
    # Selects what needs to be done for fields.
    #
    def work_fields
      added = proposed.fields.select { |f| !current.fields.include?(f) }
      removed = current.fields.select { |f| !proposed.fields.include?(f) }
      # changed = current.fields.select do |k, v|
      #   proposed.fields[k] && v != proposed.fields[k]
      # end
      p added
      p removed
      added.each(&:add!)
      removed.each(&:del!)
      # change_fields changed
    end

    #
    # Selects what needs to be done for indexes.
    #
    def work_indexes
      added = proposed.indexes.select { |k| !current.indexes.include?(k) }
      removed = current.indexes.select { |k| !proposed.indexes.include?(k) }

      added.each(&:add!)
      removed.each(&:del!)
    end

    # def migration
    #   # verb = table[:new] ? 'Create'
    #   data = table.fields
    # end


    #
    # Creates tables
    #
    def add!
      puts "Create table '#{name}' for #{model}"
      return if Schemaless.sandbox
      if Schemaless.migrate
        ::ActiveRecord::Migration.send(:create_table, name, *opts)
      else
        "create_table #{name}, #{opts}"
      end
    end

    def del!
      ::ActiveRecord::Migration.drop_table(:users)
    end
  end
end
