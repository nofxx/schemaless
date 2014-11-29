module Schemaless
  #
  # Fields
  #
  class Field
    attr_accessor :table, :name, :type, :opts, :dynamic

    def initialize(table, name, type, opts = {})
      @table = table
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
    def add_field!
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.add_column(table, name, type)
    end

    #
    # Delete Fields
    #
    def del_field!
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.remove_column(table, name)
    end

    #
    # Change Fields
    #
    def change_fields(_table, _fields)
      # ::ActiveRecord::Migration.change_column(table, name)
      # ::ActiveRecord::Migration.change_column_null(table, name)
      # ::ActiveRecord::Migration.change_column_default(table, name)
    end

    def migration(act)
      extra = opts.empty? || act == :remove ? nil : ", #{extra.inspect}"
      "#{act}_column '#{table}', '#{name}', :#{type}#{extra}"
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
