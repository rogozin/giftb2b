class Supplier < ActiveRecord::Base
  has_many :products
  validates :name, :uniqueness => true
end
