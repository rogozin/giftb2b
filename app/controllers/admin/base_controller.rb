#encoding: utf-8;
class Admin::BaseController < ApplicationController
  before_filter :require_user
  layout 'admin'
end
