class Lk::BaseController < ApplicationController
  before_filter :require_user
  layout 'lk'
end
