class ContentCategory < ActiveRecord::Base
  validates :name, :presence => true,  :length => { :maximum => 255 }  
  validates :permalink,  :length => { :maximum => 255 }, :uniqueness => true

  before_save :set_permalink
  
  has_many :contents  
  
  has_many :active_pages, :class_name => "Content", :conditions => "draft = 0 and (stop is null or stop > now()) and (start is null or start < now())", :order => "created_at desc"  

  def set_permalink
    if self.permalink.blank? 
      self.permalink = self.name.parameterize
    end
  end

  def to_param
    self.permalink
  end

end
