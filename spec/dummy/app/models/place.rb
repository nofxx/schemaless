#
# Test model
class Place < ActiveRecord::Base
  field :name
  field :geom, type: Array

  index :name
end
