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
  if defined? Rails && Rails.env =~ /production/
    autoload :ActiveRecord, 'schemaless/ar/stubs'
  else
    autoload :ActiveRecord, 'schemaless/ar/fields'
    autoload :ActiveRecord, 'schemaless/ar/indexes'
  end

  class << self
    attr_accessor :sandbox # Sandbox mode for live
  end
end

require 'schemaless/railtie' if defined? Rails
