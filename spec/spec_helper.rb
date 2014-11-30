require 'rubygems'
# require 'pry'
begin
  require 'spec'
rescue LoadError
  require 'rspec'
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
ENV['RAILS_ENV'] ||= 'test'

require 'rails'
require 'active_record'
puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

require 'schemaless' # /active_record'
# ActiveRecord::Base.send :include, Schemaless::Fields

require File.expand_path('../dummy/config/environment.rb', __FILE__)
# require 'i18n'
require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

# I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml')]
# I18n.default_locale = 'pt'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

Rails.application.eager_load!

RSpec.configure do |config|

  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.before(:each) do
    [:users, :bikes, :places, :user_skills, :user_extras].each do |db|
      ActiveRecord::Migration.drop_table(db) rescue nil # rubocop:disable Style/RescueModifier
    end
    CreateTestingStructure.new.change
    Schemaless.sandbox = nil
  end

  config.after(:each) do
  end

end
