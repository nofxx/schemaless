require 'rails/generators'
require 'rails/generators/migration'

module Schemaless
  # Generates migrations for schemaless safe mode
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, type: :array # , default: [] # , banner: 'path'
    desc 'Schemaless config files generator!'

    def create_migration_file
      set_local_assigns!
      # validate_file_name!
      migration_template @migration_template, "db/migrate/#{file_name}.rb"
    end

    protected

    attr_reader :table_name, :fields, :indexes, :migration_action, :join_tables

    def file_name
      return @file_name if @file_name
      table = attributes.first
      return "create_#{table.name}" unless table.exists?
      name = []
      if table.new_fields.any?
        name << :add
        name << (table.new_fields.size > 3 ? :many : table.new_fields)
        name << (table.old_fields.any? ? :and : :to)
      end
      if table.old_fields.any?
        name << :remove
        name << (table.old_fields.size > 3 ? :many : table.old_fields)
        name << :from
      end
      name << table_name
      @file_name = name.flatten.join('_')
    end

    # sets the default migration template that is being
    # used for the generation of the migration
    # depending on the arguments which would be sent
    # out in the command line, the migration template
    # and the table name instance variables are setup.
    def set_local_assigns!
      @migration_template = 'migration.rb'
      @table              = attributes.first
      @table_name         = @table.name

      @fields  = { add: @table.new_fields, remove: @table.old_fields }
      @indexes = { add: @table.new_indexes, remove: @table.old_indexes }

      # case file_name
      # when /join_table/
      #   if attributes.length == 2
      #     @migration_action = 'join'
      #     @join_tables      = if pluralize_table_names?
      #                           attributes.map(&:plural_name)
      #                         else
      #                           attributes.map(&:singular_name)
      #                         end

      #     set_index_names
      #   end

      @migration_template = 'create_table_migration.rb' if file_name =~ /^create_(.+)/
    end

    def set_index_names
      attributes.each_with_index do |attr, i|
        attr.index_name = [attr, attributes[i - 1]].map { |a| index_name_for(a) }
      end
    end

    def index_name_for(attribute)
      if attribute.foreign_key?
        attribute.name
      else
        attribute.name.singularize.foreign_key
      end.to_sym
    end

    private

    def attributes_with_index
      attributes.select { |a| !a.reference? && a.has_index? }
    end

    # def validate_file_name!
    #   unless file_name =~ /^[_a-z0-9]+$/
    #     fail IllegalMigrationNameError, file_name
    #   end
    # end

    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end
  end
end
