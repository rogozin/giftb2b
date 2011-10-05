#encoding: utf-8;
class LkOrder < ActiveRecord::Base
  has_many :lk_order_items, :dependent => :destroy
  has_many :lk_order_logs
  belongs_to :firm
  belongs_to :lk_firm
  belongs_to :user
  before_create :set_random_link
  after_save :set_log
  
  validates :user_email, :email => {:allow_blank => true}
  validates :firm_id, :presence => true

  def self.statuses
    [["заказ в обработке",0],["выставлен счет на оплату заказа",10],["макет на утверждении", 20],
    ["заказ на производстве",30], ["заказ собран", 40], ["заказ отгружен",50]]
  end
  
    
  def status
   st = LkOrder.statuses.find{|x| x.last == self.status_id}
   st ? st.first : "-"
  end
  
  def sum
    lk_order_items.sum("price*quantity")
  end
  
  def contact_email
    user_email.present? ? user_email : lk_firm.email
  end
  
  private
  
  def gen_random_link
    (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
  end
  
  def set_random_link
    self.random_link = gen_random_link
  end
  
  def set_log
    if lk_order_logs.blank? || self.status_id != lk_order_logs.last.status_id || self.user_id != lk_order_logs.last.user_id
      lk_order_logs.create({:status_id => self.status_id, :user_id => self.user_id})
    end
  end
 
end
