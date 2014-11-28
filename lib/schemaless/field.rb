module Schemaless
  #
  # Fields
  #
  class Field
    attr_accessor :table, :name, :type, :opts, :dynamic

    def initialize(table, name, type, *opts)
      @table = table
      @name = name
      @type = map_field type
      @opts = opts
    end

    def <=>(other)
      name == other.name && type == other.type
    end

    #
    # Add Fields
    #
    def add!
      return if fields.empty?
      # print_work('++ Field', fields, table)
      return if Schemaless.sandbox
      fields.each do |field, type|
        if Schemaless.migrate
          ::ActiveRecord::Migration.send(:add_column, table, field, type)
        else
          "add_column #{table}, #{field}, #{type}"
        end
      end
    end

    #
    # Delete Fields
    #
    def del!
      return if fields.empty?
      # print_work('-- Field', fields, table)
      return if sandbox
      fields.each do |field, _type|
        if Schemaless.migrate
          ::ActiveRecord::Migration.send(:remove_column, table, field)
        else
          "add_column #{table}, #{field}, #{type}"
        end
      end
    end

    #
    # Change Fields
    #
    def change_fields(_table, _fields)
    end

    #
    # binary    # boolean
    # date      # datetime
    # time      # timestamp
    # integer   # primary_key    # references
    # decimal   # float
    # string    # text
    # hstore
    # json
    # array
    # cidr_address
    # ip_address
    # mac_address
    def map_field(field)
      return field if field.is_a?(Symbol)
      case field.to_s
      when /Integer|Fixnum|Numeric/ then :integer
      when /BigDecimal|Rational/ then :decimal
      when /Float/      then :float
      when /DateTime/   then :datetime
      when /Date/       then :date
      when /Time/       then :timestamp
      else
        :string
      end
    end
  end
end
