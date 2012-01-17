class Service < ActiveRecord::Base
  has_many :service_roles, :dependent => :delete_all
end
