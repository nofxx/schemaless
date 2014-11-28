#
# Schemaless Trouble to Worry!
#
require 'schemaless/field'
require 'schemaless/index'
require 'schemaless/table'
require 'schemaless/schema'
require 'schemaless/work'

module Schemaless
  autoload :ActiveRecord, 'schemaless/active_record'

  class << self
    attr_accessor :sandbox # Sandbox mode for live
    attr_accessor :migrate # Migrate or create text migration
    attr_accessor :schema  # Just for the irony

    def self.live!
      Work.new(:live)
    end
    def self.text!
      Work.new(:text)
    end
  end
end

require 'schemaless/railtie' if defined? Rails
