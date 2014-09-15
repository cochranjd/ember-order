class Menuitem < ActiveRecord::Base
  has_many :selections
  has_many :orders, :through => :selections
end
