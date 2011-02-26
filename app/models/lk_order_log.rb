class LkOrderLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :lk_order
  
  def status
   st = LkOrder.statuses.find{|x| x.last == self.status_id}
   st ? st.first : "-"
  end
end
