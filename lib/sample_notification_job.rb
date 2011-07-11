
class SampleNotificationJob
  def perform
    Sample.return_to_supplier_in_two_days.where("responsible_id > 0").each do |sample|
      LkMailer.returning_sample_to_supplier(sample).deliver unless sample.responsible.email.blank?
    end
    Sample.return_from_client_in_two_days.where("responsible_id > 0").each do |sample|
      LkMailer.returning_sample_from_client(sample).deliver unless sample.responsible.email.blank?
    end    
  end
  
end
