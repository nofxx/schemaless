class Rider < ActiveRecord::Base
  field :name
  field :position, Integer

  index :position
  index [:name, :position]

end
