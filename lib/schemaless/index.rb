module Schemaless
  #
  # Stores indexes
  #
  class Index
    attr_accessor :fields, :name, :opts
    VALID_OPTS = [:unique, :orders]

    def initialize(fields, name = nil, opts = {})
      @fields = [fields].flatten
      @fields = @fields.first if @fields.size == 1
      @name = name || opts[:name]
      @opts = opts.select { |_k, v| v.present?  }
      @opts.merge!(name: @name) if @name
    end

    def opts_text
      txt = opts.map { |k, v| "#{k}: #{v}" }.join(', ')
      txt.empty? ? '' : ", #{txt}"
    end

    def fields_text
      @fields.inspect
    end

    def to_s
      name
    end

    def ==(other)
      name == other.name
    end

    #
    # Add Indexes
    #
    def add!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.add_index(table.name, fields, opts)
    end

    #
    # Delete Indexes
    #
    def remove!(table)
      return if Schemaless.sandbox
      key = name ? { name: name } : { column: fields }
      ::ActiveRecord::Migration.remove_index(table.name, key)
    end

    #
    # Change Indexes
    #
    def change!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.change_index(table.name, name, type, opts)
    end
  end
end
