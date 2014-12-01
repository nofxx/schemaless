module Schemaless
  # Generates schemaless setup for rails app
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, type: :array, default: [], banner: 'path'
    desc 'Schemaless config files generator!'

    def create_config_file
      gem 'schemaless'
      application 'config.middeware.use SchemalessMiddleware'
      # initializer | application
      # copy 'schemaless.rb'
    end
  end
end
