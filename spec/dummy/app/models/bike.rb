#
# Test model
class Bike < ActiveRecord::Base
  field :name

  field :cylinders, type: Integer # Fixed
  field :rpm, type: Integer       # Change
  field :cc, type: Integer        # Add

  belongs_to :user

  index :cylinders
  index :name
  index :cc

end
