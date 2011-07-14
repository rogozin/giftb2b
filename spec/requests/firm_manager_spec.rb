#encoding: utf-8;
require 'spec_helper'


describe 'Роль менеджер фирмы' do
   it 'я могу поставить признак возврата денег на странице образца' do
     login_as :firm_manager
     @user.has_role! "Учет образцов"
     @sample = Factory(:sample, :closed => true)
     visit edit_lk_sample_path(@sample)
     page.should have_checked_field "sample_closed"
   end
end
