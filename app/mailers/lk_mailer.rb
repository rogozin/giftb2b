#encoding: utf-8;
class LkMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru", :charset => "UTF-8"
   layout "/layouts/mailer"

  def returning_sample_to_supplier(sample_id)
    @sample  = Sample.find(sample_id)
    mail(:to => @sample.responsible.email, :subject => "Образцы: возврат поставщику (#{sample_id})")
  end

  def returning_sample_from_client(sample_id)
    @sample  = Sample.find(sample_id)
    mail(:to => @sample.responsible.email, :subject => "Образцы: возврат от клиента (#{sample_id})")
  end
  
end
