class LkOrder < ActiveRecord::Base
  has_many :lk_order_items, :dependent => :delete_all
  belongs_to :firm
  belongs_to :lk_firm
  belongs_to :user
  before_create :set_random_link

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
  
  private
  
  def gen_random_link
    (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
  end
  
  def set_random_link
    self.random_link = gen_random_link
  end
  
 
end
