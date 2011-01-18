class Lk::BaseController < ApplicationController
  before_filter :require_user
  layout 'lk'

 
  
  def not_firm_assigned!
    flash[:error] = "Вам не назначена фирма!"
  end
  private :not_firm_assigned!
end
