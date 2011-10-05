require "auth/engine"

module Auth
  def test_auth
    "module auth"
  end
end

ActionController::Base.send(:include, Auth)
