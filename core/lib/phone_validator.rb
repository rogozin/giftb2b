#encoding: utf-8
class PhoneValidator < ActiveModel::EachValidator

  cattr_reader :phone_pattern
  @@phone_pattern = /^\+\d{1,3}\(\d{1,5}\)\d{3}-\d{1,4}$/
  
  def validate_each(record, attribute, value)    
   record.errors[attribute] << (options[:message] || " имеет не правильный формат") unless value =~ @@phone_pattern
  end

end
