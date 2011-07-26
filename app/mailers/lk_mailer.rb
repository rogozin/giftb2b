#encoding: utf-8;
class LkMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru", :charset => "UTF-8"
   layout "/layouts/mailer"

  def returning_sample_to_supplier(sample)
    @sample  = sample
    mail(:to => sample.responsible.email, :subject => "Образцы: возврат поставщику (#{sample.id})")
  end

  def returning_sample_from_client(sample)
    @sample  = sample
    mail(:to => sample.responsible.email, :subject => "Образцы: возврат от клиента (#{sample.id})")
  end
  
end
