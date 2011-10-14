#encoding: utf-8;
module LoginSpecHelper
  
  def login_as user_role
    @user = Factory(user_role)
    visit "/auth/login"
    within "#login" do
      fill_in "user_session[username]", :with => @user.username
      fill_in "user_session[password]", :with => @user.password
      click_button "Войти"
    end
  end
  
  def gen_content(length=10)
    fr_chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    data = ""
    1.upto(length) { |i| data << fr_chars[rand(fr_chars.size-1)] }
    data
  end

end
