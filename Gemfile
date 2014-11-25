source 'https://rubygems.org'

gemspec

group :test do
  gem 'bson_ext', platform: :ruby
  gem 'sqlite3',  platform: :ruby
  gem 'pg',       platform: :ruby

  gem 'activerecord-jdbcmysql-adapter',   platform: :jruby
  gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby

  gem 'coveralls', require: false if ENV['CI']
end
