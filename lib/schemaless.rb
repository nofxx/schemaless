#
# Schemaless Trouble to Worry!
#
require 'schemaless/field'
require 'schemaless/index'
require 'schemaless/table'
require 'schemaless/worker'

#
# Schemaless
#
#
# Life without migrations!
#
#
module Schemaless
  autoload :ActiveRecord, 'schemaless/active_record'

  class << self
    attr_accessor :sandbox # Sandbox mode for live
    attr_accessor :migrate # Migrate or create text migration
  end
end

require 'schemaless/railtie' if defined? Rails
