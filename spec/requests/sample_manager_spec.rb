#encoding: utf-8;
require 'spec_helper'

describe 'i am sample_manager' do
  before(:each) do
    login_as :sample_manager
  end
  
  it "я вижу ссылку Образцы" do
      visit "/admin"
      within "#admin-menu" do
        page.should have_content("Образцы")
      end
      visit '/admin/samples'
      page.should have_content "Учет образцов"
  end
  
  it 'я могу добавить поставщика' do
    
  end
  
  it 'я могу добавить фирму' do
    
  end
end
