# Rails 3 initialization
module Schemaless
  require 'rails'
  # Rails include
  class Railtie < Rails::Railtie
    initializer 'schemaless.insert_into_active_record' do
      ActiveSupport.on_load :active_record do
        if Rails.env =~ /production/
          ::ActiveRecord::Base.send :include, Schemaless::Stubs
        else
          ::ActiveRecord::Base.send :include, Schemaless::Fields
          ::ActiveRecord::Base.send :include, Schemaless::Indexes
        end
      end
    end
    rake_tasks do
      load 'tasks/schemaless_tasks.rake'
    end
  end
end
