lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'schemaless/version'

Gem::Specification.new do |s|
  s.name        = 'schemaless'
  s.version     = Schemaless::VERSION

  s.authors     = ['Marcos Piccinini']
  s.description = 'ActiveRecord field & index!'
  s.homepage    = 'http://github.com/nofxx/schemaless'
  s.summary     = 'Schemaless dynamic attributes for ActiveRecord'
  s.email       = 'x@nofxx.com'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*'] + %w(README.md Rakefile)
  s.test_files = Dir['spec/**/*']
  s.require_path = 'lib'

  s.add_dependency 'rails'
  #s.add_dependency 'activemodel'
  #s.add_dependency 'activesupport'

  # s.add_development_dependency 'pg'
  # s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'activerecord'
  # s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rubocop'

end
