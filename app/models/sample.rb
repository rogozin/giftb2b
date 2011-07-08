#encoding: utf-8;
class Sample < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :firm
  belongs_to :user
  belongs_to :responsible, :foreign_key => :responsible_id, :class_name => "User"
  validates :name, :presence => true
  validates :supplier_id, :presence => true
  validates :firm_id, :presence => true
  validates :user_id, :presence => true
  validates :sale_price, :buy_price, :numericality => {:allow_nil => true, :greater_than_or_equal_to => 0}
  validate :sale_date_validation
  validate :client_return_date_validation
  
  
  private
  
  def sale_date_validation
    errors.add(:sale_date, "не может быть меньше даты покупки") if sale_date && buy_date && sale_date < buy_date
  end
  
  def client_return_date_validation
    errors.add(:client_return_date, "не может быть больше даты возврата поставщику") if client_return_date && supplier_return_date && client_return_date > supplier_return_date
  end
end
