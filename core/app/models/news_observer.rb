#encoding:utf-8;
class NewsObserver < ActiveRecord::Observer
  def after_save(news)
    if news.state_id_changed? && news.state_id_was == 3    
     User.joins(:role_objects).where("active = 1 and (roles.name='Администратор' or roles.name='Редактор контента')").each do |admin|
       begin
        Auth::AdminMailer.new_news_created(news, admin).deliver
       rescue => err
        ActiveRecord::Base.logger.info("message_send_error #{err}") if ActiveRecord::Base.logger
       end
     end
   end
  end
end
