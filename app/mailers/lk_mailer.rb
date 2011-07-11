#encoding: utf-8;
class LkMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru"

  def returning_sample_to_supplier(sample)
    @sample  = sample
    mail(:to => sample.responsible.email, :subject => "Образцы: возврат поставщику")
  end

  def returning_sample_from_client(sample)
    @sample  = sample
    mail(:to => sample.responsible.email, :subject => "Образцы: забрать от клиента")
  end
  
end
