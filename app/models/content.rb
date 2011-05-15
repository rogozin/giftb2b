class Content < ActiveRecord::Base
  validates :title, :presence => true,  :length => { :maximum => 255 }  
  validates :permalink,  :length => { :maximum => 255 }, :uniqueness => true

  before_save :set_permalink
  validate :check_dates

  belongs_to :content_category

  scope :active, where("draft = 0 and (stop is null or stop > now()) and (start is null or start < now())")
  
  def active?
    !draft && (start || Time.now-1.day) <= Time.now && (stop || Time.now + 1.day)  >= Time.now
  end  

  def to_param
    self.permalink
  end
  
  def set_permalink
    if self.permalink.blank? 
      self.permalink = self.title.parameterize
    end
  end

  def check_dates 
    if stop && start && stop < start
      errors.add(:stop, "Неверное значение") 
      false
    end
  end
  
end
