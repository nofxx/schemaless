#
# Test model
class Bike < ActiveRecord::Base
  field :name
  field :cylinders, kind: Integer
  field :cc, kind: Integer
end
