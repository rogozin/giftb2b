When /^I login as "([^"]*)"$/ do |arg1|
  CurrencyValue.create({:dt => Date.today, :usd => 30, :eur => 40})
  visit '/logout'
  Rails.cache.clear
  @user = Factory(arg1)
  visit "/"
  fill_in "user_session[username]", :with => @user.username
  fill_in "user_session[password]", :with => @user.password
  submit_form "login_form"
end
