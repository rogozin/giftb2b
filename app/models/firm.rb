class Firm < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :email,
  :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}  
  validates :url,
  :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}
  

  
end
