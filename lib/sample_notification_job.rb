#encoding:utf-8;

class SampleNotificationJob
 attr_reader :logger

  def perform
      log = File.new(File.join(Rails.root,'log/samples.log'), 'a+')
      @logger = Logger.new(log)  
      logger.info("#{Time.now} подготовка к отправке уведомлений...")
      db = ActiveRecord::Base.configurations[Rails.env]
      
      client = Mysql2::Client.new(:host => db["host"], :username => db["username"], :password => db["password"])
      client.query("select id, supplier_return_date from #{db["database"]}.samples where closed=0 and responsible_id > 0 and supplier_return_date is not null and (supplier_return_date = curdate()  or supplier_return_date  = adddate(curdate(),2) )").each do |row|
        logger.info("#{Time.now} отправляю письмо - возврат поставщику, id =: #{row["id"]} возврат #{row["supplier_return_date"]}")
        LkMailer.returning_sample_to_supplier(row["id"]).deliver
      end 
      client.query("select id, client_return_date from #{db["database"]}.samples where closed=0 and responsible_id > 0 and client_return_date is not null  and  (client_return_date = curdate()  or client_return_date  = adddate(curdate(),2))").each do |row|
        logger.info("#{Time.now} отправляю письмо - возврат от клиента, id =: #{row["id"]} возврат #{row["client_return_date"]}")
        LkMailer.returning_sample_from_client(row["id"]).deliver
      end     
      #deliver_sup(Sample.return_to_supplier_today)
      #deliver_sup(Sample.return_to_supplier_in_two_days)
      #deliver_client(Sample.return_from_client_today)
      #deliver_client(Sample.return_from_client_in_two_days)
      #log.close
  end
  
#  def deliver_client(sample_collection)
#    sample_collection.each do |sample|
#     logger.info("#{Time.now} отправляю письмо - возврат от клиента, id =: #{sample.id} возврат #{sample.client_return_date}")
#     LkMailer.returning_sample_from_client(sample).deliver unless sample.responsible.email.blank?
#    end
#  end
#  
#  def deliver_sup(sample_collection)
#    sample_collection.each do |sample|
#     logger.info("#{Time.now} отправляю письмо - возврат поставщику, id =: #{sample.id} возврат #{sample.supplier_return_date}")
#     LkMailer.returning_sample_to_supplier(sample).deliver unless sample.responsible.email.blank?
#    end
#  end

  
end
