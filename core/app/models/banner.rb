#encoding: utf-8;
class Banner < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :presence => true
  scope :active, lambda {|pos|  where(:site => Banner.site_no, :active => true, :position => pos) }
  after_save :clear_cahce
  
  def self.types
    [["HTML",0],["Image", 1]]
  end
  
  def self.cached_active_banners(position)
    Rails.cache.fetch("active_banners/#{position}") {  active(position).all }    
  end
  
  def type
    Banner.types[type_id].first
  end
  
  def show_on_page?(page = "")
    pages.blank? || pages.split(";").map(&:strip).any?{|x| page.match(x) }
  end
  
  private 
  
  def self.site_no
    ActionMailer::Base.default_url_options[:host] == "giftb2b.ru" ? 0 : 1
  end
  
  def clear_cahce
   Rails.cache.delete("active_banners/#{self.position}")
  end
end
