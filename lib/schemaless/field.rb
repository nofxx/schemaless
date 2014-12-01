module Schemaless
  #
  # Fields
  #
  class Field
    attr_accessor :name, :type, :opts, :default, :index
    VALID_OPTS = [:type, :limit, :precision, :scale, :null, :default, :index]

    #
    # Field - name, type, opts: [:default, :null, :unique]
    #
    def initialize(name, type, opts = {})
      fail InvalidArgument, 'opts must be a hash' unless opts.is_a?(Hash)
      @name = name.to_s
      @type = map_field type
      @opts = opts.select { |_k, v| v.present? }
      @opts[:null] = true unless @opts[:null].present?
      @opts[:limit] = 255 unless @opts[:limit].present? || @type != :string
    end

    def ==(other)
      name == other.name #  && type == other.type
    end

    def reference?
    end

    def opts_text
      txt = opts.map { |k, v| "#{k}: #{v}" }.join(', ')
      txt.empty? ? '' : ", #{txt}"
    end

    def to_s
      name
    end

    #
    # Add Fields
    #
    def add!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.add_column(table.name, name, type, opts)
    end

    #
    # Delete Fields
    #
    def remove!(table)
      return if Schemaless.sandbox
      ::ActiveRecord::Migration.remove_column(table.name, name)
    end

    #
    # Change Fields
    #
    def change!(table)
      return if Schemaless.sandbox
      # ::ActiveRecord::Migration.change_column(table, name)
      # ::ActiveRecord::Migration.change_column_null(table, name)
      # ::ActiveRecord::Migration.change_column_default(table, name)
      ::ActiveRecord::Migration.change_column(table.name, name, type, opts)
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
    #
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
