# require 'pry'
require 'schemaless/field'
require 'schemaless/index'
require 'schemaless/table'
require 'schemaless/worker'

require 'generators/schemaless/migrations/migrations_generator'
#
#           Schemaless
# +_____________________________+
# |      |         |            |
# | Life | without | migrations !
# |______|_________|____________|
#
module Schemaless
  class << self
    attr_accessor :sandbox # Sandbox mode for live
  end
end

require 'schemaless/railtie' if defined? Rails
