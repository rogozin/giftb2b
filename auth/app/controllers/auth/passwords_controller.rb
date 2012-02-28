class Auth::PasswordsController < Devise::PasswordsController
  include Auth::DeviseMix
  before_filter proc{prepend_view_path "/home/ilya/ROR/work/gift/auth/app/views/"}
end
