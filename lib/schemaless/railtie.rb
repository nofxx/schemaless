# Rails 3 initialization
module Schemaless
  require 'rails'
  # Rails include
  class Railtie < Rails::Railtie
    initializer 'schemaless.insert_into_active_record' do
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.send :include, Schemaless::ActiveRecord
      end
    end
    rake_tasks do
      load 'tasks/schemaless_tasks.rake'
    end
  end
end
