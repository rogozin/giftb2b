Giftr3::Application.configure do
#config.action_mailer.delivery_method = :sendmail
# Defaults to:
# config.action_mailer.sendmail_settings = {
#   :location => '/usr/sbin/sendmail',
#   :arguments => '-i -t'
# }

config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address              => "127.0.0.1",
  :port                 => 25,
  :domain               => 's01.giftb2b.ru',
#  :user_name            => '***',
#  :password             => '***',
  :authentication       => "none",
#  :enable_starttls_auto => true  
}

config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors = true
config.action_mailer.default_url_options = { :host => "giftb2b.ru" }
end
