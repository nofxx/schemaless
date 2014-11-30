module Schemaless
  #
  # Stores indexes
  #
  class Index
    attr_accessor :name, :opts

    def initialize(name, opts = {})
      @name   = name.to_s
      @opts   = opts
      @unique = opts.delete(:unique) == true
    end

    def to_s
      name
    end

    def unique?
    end
    #
    # Add Indexes
    #
    def add!(table)
      # print_work('++ Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      ::ActiveRecord::Migration.add_index(table.name, name)
    end

    #
    # Delete Indexes
    #
    def del!(table)
      # print_work('-- Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      ::ActiveRecord::Migration.remove_index(table.name, name)
    end

  end
end
