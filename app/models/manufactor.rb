#encoding: utf-8;
class Manufactor < ActiveRecord::Base
  has_many :products
end

