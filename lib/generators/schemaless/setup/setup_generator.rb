# require 'rails/generators/active_record'

# Schemaless Generators
class Schemaless::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  #namespace :schemaless
  argument :attributes, type: :array, default: [], banner: 'path'
  desc 'Schemaless config files generator!'

  def create_config_file
    gem 'schemaless'
    # initializer | application
    # copy 'schemaless.rb'
  end
end
