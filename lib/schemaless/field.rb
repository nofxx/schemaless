module Schemaless
  #
  # Fields
  #
  class Field
    attr_accessor :name, :type, :opts, :dynamic

    def initialize(name, type, opts = {})
      @name = name.to_s
      @type = map_field type
      @opts = opts
    end

    def ==(other)
      name == other.name #  && type == other.type
    end

    #
    # Add Fields
    #
    def add!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.add_column(table.name, name, type)
    end

    #
    # Delete Fields
    #
    def del!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.remove_column(table.name, name)
    end

    #
    # Change Fields
    #
    def change_fields(_table, _fields)
      # ::ActiveRecord::Migration.change_column(table, name)
      # ::ActiveRecord::Migration.change_column_null(table, name)
      # ::ActiveRecord::Migration.change_column_default(table, name)
    end

    def reference?
    end

    def to_s
      name
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
    def map_field(field) # rubocop:disable Metrics/MethodLength
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
