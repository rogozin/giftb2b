#encoding: utf-8
class PhoneValidator < ActiveModel::EachValidator

  cattr_reader :phone_pattern
  @@phone_pattern = /^\+\d{1,3}\(\d{1,5}\)\d{3}-\d{1,4}$/
  
  def validate_each(record, attribute, value)    
   record.errors[attribute] << (options[:message] || " имеен не правильный формат") unless value =~ @@phone_pattern
   record.errors[attribute] << (options[:message] || " такой телефон уже есть") if record.is_a?(Client) &&  Firm.exists?(["(id <> :firm_id) and (phone = :val OR phone2 = :val OR phone3 = :val)", {:firm_id => record.persisted? ? record.id : -1, :val => value }])
  end

end
