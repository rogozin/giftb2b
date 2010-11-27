class CurrencyValue < ActiveRecord::Base
  validates_uniqueness_of :dt
  after_save  :clear_cache
  after_destroy :clear_cache

def self.kurs(valuta='RUB')
 val= Rails.cache.fetch('kurs') {find(:last, :conditions=> ["dt<=?", Date.today],:select =>"id,usd,eur")}
  case valuta
    when 'USD'
      val.usd.to_f
    when 'EUR'
      val.eur.to_f
    else 
      1    
  end
end
    
private

def clear_cache
  Rails.cache.delete('kurs')
end
end
