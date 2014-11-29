module Schemaless
  #
  # Stores indexes
  #
  class Index
    attr_accessor :table, :name, :opts

    def initialize(table, name, opts = {})
      @table  = table
      @name   = name.to_s
      @opts   = opts
      @unique = opts.delete(:unique) == true
    end

    def unique?
    end
    #
    # Add Indexes
    #
    def add_index!
      # print_work('++ Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      ::ActiveRecord::Migration.send(:add_index, table, name)
    end

    #
    # Delete Indexes
    #
    def del_index!
      # print_work('-- Index', indexes, table)
      return if Schemaless.sandbox
      # indexes.each do |index, _type|
      ::ActiveRecord::Migration.send(:remove_index, table, name)
    end

    def migration(act)
      extra = opts.empty? || act == :remove ? nil : ", #{opts.inspect}"
      "#{act}_index '#{table}', '#{name}'#{extra}"
    end
  end
end
