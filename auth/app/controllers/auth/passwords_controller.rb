class Auth::PasswordsController < Devise::PasswordsController
  include Auth::DeviseMix
end
