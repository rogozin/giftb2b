#encoding: utf-8;
class ForeignAccess < ActiveRecord::Base
  belongs_to :firm
  before_save :clear_cache
  validates :name, :presence => true
  #validates :ip_addr, :presence => true
  #validates :firm_id, :presence => true

  def self.accepted_clients
    Rails.cache.fetch('accepted_clients', :expires_in =>1.hours) { ForeignAccess.find(:all, :conditions =>"accepted_from <= now()  and accepted_to >= now()")}
  end
 
 
private
  
 def clear_cache
      Rails.cache.delete('accepted_clients')   
      self[:accepted_from] = Time.now if self[:accepted_from].blank?
 end


end
