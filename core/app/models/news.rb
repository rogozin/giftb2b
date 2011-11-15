#encoding:utf-8;
class News < ActiveRecord::Base
  
  belongs_to :firm
  belongs_to :created_author, :class_name => "User", :foreign_key => "created_by"
  validates :title, :presence => true
  validates :permalink, :uniqueness => {:allow_nil => false}
  validates :firm_id, :presence => true
  has_attached_file :picture, :styles => {:thumb => ["300", :png] },
     :path =>":rails_root/public/system/news/:firm_id/:id/:style/:filename",
   :url  => "/system/news/:firm_id/:id/:style/:filename"

  scope :active, where(:state_id => 1).order("created_at desc")
  scope :latest, active.limit(5)
  before_create :prepare_permalink
  
  after_save :clear_cache
  after_destroy :clear_cache
  
  def self.states
    { "На модерации" => 0, "Опубликовано" => 1, "Архив" => 2, "Черновик" => 3, "Отклонена" => 4 }
  end
  
  def to_param
    self.permalink
  end
  
  def self.cached_latest_news
    Rails.cache.fetch("latest_news"){ News.latest.all }
  end
  
  def state
    self.class.states.flatten[state_id*2]
  end  
  
  private     
  
  def clear_cache
    Rails.cache.delete("latest_news")
  end
  
  def prepare_permalink
   self.permalink =   News.exists?(:permalink =>self.title.parameterize) ? "#{self.title.parameterize}-#{Time.now.to_s(:db).parameterize}" : self.title.parameterize
  end

  
  
end
