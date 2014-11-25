#
# Test model
class Place < ActiveRecord::Base
  field :name
  field :geom, kind: Array
end
