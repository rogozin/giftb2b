#encoding: utf-8;
require 'spec_helper'

describe 'Показ баннеров' do
  before(:each) do
    @banner = Banner.create(:firm_id => 1, :text => "<div class=\"banner\">КУПИТЕ СУВЕНИРЫ</div>", :active => true, :position => 1, :site => 0)
  end
  
  it 'я вижу баннер на гифте' do
    Settings.stub(:site_id).and_return(0)
    visit '/'
    page.should have_selector("div.banner")
  end


  it 'я не вижу баннер на гифтпоиске' do
    Settings.stub(:site_id).and_return(1)
    visit '/'
    page.should have_no_selector("div.banner")
  end

  
end
