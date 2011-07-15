
class SampleNotificationJob
  def perform
      deliver_sup(Sample.return_to_supplier_today)
      deliver_sup(Sample.return_to_supplier_in_two_days)
      deliver_client(Sample.return_from_client_today)
      deliver_client(Sample.return_from_client_in_two_days)
  end
  
  def deliver_client(sample_collection)
    sample_collection.each do |sample|
     LkMailer.returning_sample_from_client(sample).deliver unless sample.responsible.email.blank?
    end
  end
  
  def deliver_sup(sample_collection)
    sample_collection.each do |sample|
     LkMailer.returning_sample_to_supplier(sample).deliver unless sample.responsible.email.blank?
    end
  end

  
end
