class User < ActiveRecord::Base
  has_many :selections
  has_many :pets, through: :selections
end
