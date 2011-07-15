
class SampleNotificationJob
  def perform
      deliver_sample(Sample.return_to_supplier_today)
      deliver_sample(Sample.return_to_supplier_in_two_days)
      deliver_sample(Sample.return_from_client_today)
      deliver_sample(Sample.return_from_client_in_two_days)
  end
  
  def deliver_sample(sample_collection)
    sample_collection.each do |sample|
     LkMailer.returning_sample_from_client(sample).deliver unless sample.responsible.email.blank?
    end
  end
  
end
