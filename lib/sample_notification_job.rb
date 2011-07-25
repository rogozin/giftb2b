#encoding:utf-8;

class SampleNotificationJob
 attr_reader :logger

  def perform
      log = File.new(File.join(Rails.root,'log/samples.log'), 'a+')
      @logger = Logger.new(log)  

      deliver_sup(Sample.return_to_supplier_today)
      deliver_sup(Sample.return_to_supplier_in_two_days)
      deliver_client(Sample.return_from_client_today)
      deliver_client(Sample.return_from_client_in_two_days)
      log.close
  end
  
  def deliver_client(sample_collection)
    sample_collection.each do |sample|
     logger.info("#{Time.now} отправляю письмо - возврат от клиента, id =: #{sample.id} возврат #{sample.client_return_date}")
     LkMailer.returning_sample_from_client(sample).deliver unless sample.responsible.email.blank?
    end
  end
  
  def deliver_sup(sample_collection)
    sample_collection.each do |sample|
     logger.info("#{Time.now} отправляю письмо - возврат поставщику, id =: #{sample.id} возврат #{sample.supplier_return_date}")
     LkMailer.returning_sample_to_supplier(sample).deliver unless sample.responsible.email.blank?
    end
  end

  
end
