#
# Test model
class User < ActiveRecord::Base
  field :name
  field :number, type: Integer

  has_many :bikes

  has_many :extras, dependent: :destroy, class_name: 'UserExtra'
  has_many :skills, dependent: :destroy, class_name: 'UserSkill'
end

class UserSkill < ActiveRecord::Base
  field :kind
  belongs_to :user
end

class UserExtra < ActiveRecord::Base
  field :key
  belongs_to :user
end
