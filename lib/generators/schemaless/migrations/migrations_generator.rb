require 'rails/generators'
require 'rails/generators/migration'

module Schemaless
  # Generates migrations for schemaless safe mode
  class MigrationsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
    argument :models, type: :array, default: [] # , banner: 'path'
    desc 'Schemaless migration files generator!'

    def create_migration_files
      Rails.application.eager_load!
      all_tables = Schemaless::Worker.all_tables
      if models.empty?
        tables = all_tables
      else
        tables = all_tables.select { |t| models.include?(t.model.to_s.downcase) }
      end
      tables.each do |table|
        puts "Generating migrations for #{table}"
        create_migration_for table
      end
    end

    protected

    attr_reader :table_name, :fields, :indexes, :migration_action, :join_tables

    def build_file_name(name = [])
      if @table.fields.add.any?
        name << :add
        name << (@table.fields.add.size > 3 ? :many : @table.fields.add)
        name << (@table.fields.remove.any? ? :and : :to)
      end
      if @table.fields.remove.any?
        name << :remove
        name << (@table.fields.remove.size > 3 ? :many : @table.fields.remove)
        name << :from
      end
      name << table_name
    end

    def file_name
      return @file_name if @file_name
      return "create_#{@table_name}" unless @table.exists?
      @file_name = build_file_name.flatten.join('_')
    end

    def create_migration_for table
      @table   = table
      @fields  = @table.fields
      @indexes = @table.indexes
      @table_name = @table.name

      template = file_name =~ /^create_(.+)/ ? 'create' : 'change'
      migration_template "#{template}_table.rb", "db/migrate/#{file_name}.rb"

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
    end

    def set_index_names
      attributes.each_with_index do |att, i|
        att.index_name = [att, attributes[i - 1]].map { |a| index_name_for(a) }
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

    # def attributes_with_index
    #   attributes.select { |a| !a.reference? && a.has_index? }
    # end

    def old_migrations
      ActiveRecord::Migrator.get_all_versions
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
