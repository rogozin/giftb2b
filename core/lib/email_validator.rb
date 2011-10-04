#encoding: utf-8
class EmailValidator < ActiveModel::EachValidator

  cattr_reader :email_pattern
  @@email_pattern = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  

  def validate_each(record, attribute, value)
    unless value =~ @@email_pattern
      record.errors[attribute] << (options[:message] || "не корректный") 
    end
  end

end
