module Schemaless
  # Appreciate the irony
  class Schema
    attr_accessor :current, :proposed

    def initialize(model)
      @current = ::Schemaless::Table.from_ar(model)
      @proposed = ::Schemaless::Table.from_rb(model)
    end

    #
    # Selects what needs to be done for fields.
    #
    def work_fields
      added = proposed.fields.select { |f| !current.fields.include?(f) }
      removed = current.fields.select { |f| !proposed.fields.include?(f) }
      changed = current.fields.select do |k, v|
        proposed.fields[k] && v != proposed.fields[k]
      end
      add_fields added
      del_fields removed
      change_fields changed
    end

    #
    # Selects what needs to be done for indexes.
    #
    def work_indexes
      added = schema_code.select { |k| !schema_db.include?(k) }
      removed = indexes_old.select { |k| !indexes_new.include?(k) }

      added.each(&:add!)
      removed.each(&:del!)
    end

    def migrations
      # verb = table[:new] ? 'Create'
      data = table.fields
    end
  end
end
