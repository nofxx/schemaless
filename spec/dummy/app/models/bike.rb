#
# Test model
class Bike < ActiveRecord::Base
  field :name

  field :cylinders, kind: Integer # Fixed
  field :rpm, kind: Integer       # Change
  field :cc, kind: Integer        # Add

  belongs_to :user

  index :cc

end
