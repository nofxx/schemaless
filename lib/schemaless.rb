#
# Schemaless Trouble to Worry!
#
module Schemaless
  autoload :ActiveRecord, 'schemaless/active_record'

  class << self
    def map_field(field)
      return field if field.is_a?(Symbol)
      case field.to_s
      when /Integer|Fixnum|Numeric/ then :integer
      when /Time/ then :timestamp
      when /Date/ then :date
      else
        :string
      end
    end

    def add_table(table, *opts)
      ::ActiveRecord::Migration.send(:create_table, table, *opts)
    end

    def add_fields(table, fields)
      return if fields.empty?
      puts "Add fields #{fields} to #{table}"
      fields.each do |field, type|
        ::ActiveRecord::Migration.send(:add_column, table, field, type)
      end
    end

    def del_fields(table, fields)
      return if fields.empty?
      puts "Del fields #{fields} from #{table}"
      fields.each do |field, _type|
        ::ActiveRecord::Migration.send(:remove_column, table, field)
      end
    end

    def schema # (models)
      ::ActiveRecord::Base.descendants.reduce({}) do |a, e|
        next a if e.to_s =~ /ActiveRecord::/
        add_table(e.table_name) unless e.table_exists?
        attributes = {}
        e.columns_hash.each do |k, v|
          next if v.primary || k =~ /.*_id$/
          attributes.merge!(k => v.type)
        end
        a.merge(e.to_s => {
                  model: e,
                  attributes: attributes,
                  schemaless: e.schemaless_fields
                })
      end
    end

    def work(hsh = nil)
      hsh ||= schema
      hsh.each do |_model, data|
        # puts "Start with #{model} #{data}"
        attrs, fields = data[:attributes], data[:schemaless]
        removed = attrs.select { |n, _t| !fields.keys.include?(n) }
        added = fields.select { |n, _t| !attrs.keys.include?(n) }
        add_fields(data[:model].table_name, added)
        del_fields(data[:model].table_name, removed)
        p data
        data[:model].reset_column_information

      end
    end
  end
end

require 'schemaless/railtie' if defined? Rails
