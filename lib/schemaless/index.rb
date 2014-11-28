module Schemaless
  #
  # Stores indexes
  #
  class Index
    attr_accessor :table, :name, :opts

    def initialize(table, name, *_opts)
      @table = table
      @name  = name
      @opts  = opts
    end

    #
    # Add Indexes
    #
    def add!
      #print_work('++ Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      if Schemaless.migrate
        ::ActiveRecord::Migration.send(:add_index, table, name)
      else
        "add_index #{table}, #{nam}"
      end
    end

    #
    # Delete Indexes
    #
    def del!
      # print_work('-- Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      if Schemaless.migrate
        ::ActiveRecord::Migration.send(:remove_index, table, name)
      else
        "remove_index #{table}, #{name}"
      end
    end
  end
end
