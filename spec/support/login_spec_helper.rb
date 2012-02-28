#encoding: utf-8;
module LoginSpecHelper
  
  def login_as user_role
    @user = Factory(user_role)
    visit "/auth/login"
    within "#new_user" do
      fill_in "user[login]", :with => @user.username
      fill_in "user[password]", :with => @user.password
      click_button "Войти"
    end
  end
  
  def direct_login_as(user_role)
    @request.env["devise.mapping"]=Devise.mappings[:user]
    @user = Factory(user_role)
    sign_in @user
  end
  
  
  def gen_content(length=10)
    fr_chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    data = ""
    1.upto(length) { |i| data << fr_chars[rand(fr_chars.size-1)] }
    data
  end

end
