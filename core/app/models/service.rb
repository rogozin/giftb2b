class Service < ActiveRecord::Base
  has_many :service_roles, :dependent => :delete_all
  has_many :roles, :through => :service_roles
end
