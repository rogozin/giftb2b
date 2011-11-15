#encoding:utf-8;
class NewsObserver < ActiveRecord::Observer
  def after_save(news)
    if news.state_id_changed? && [3,4].include?(news.state_id_was)  && news.state_id == 0
     User.joins(:role_objects).where("active = 1 and (roles.name='Администратор' or roles.name='Редактор контента')").each do |admin|
       begin
        Auth::AdminMailer.new_news_created(news, admin).deliver
       rescue => err
        ActiveRecord::Base.logger.info("message_send_error #{err} #{err.message}") if ActiveRecord::Base.logger
       end
     end
   end
  end
end
