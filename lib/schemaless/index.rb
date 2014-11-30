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
      opts.map { |k, v| "#{k}: #{v}" }.join(', ')
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
    def del!(table)
      return if Schemaless.sandbox
      key = name ? { name: name } : { column: fields }
      ::ActiveRecord::Migration.remove_index(table.name, key)
    end
  end
end
