#encoding: utf-8;
require 'spec_helper'

describe News do
  it 'permalink' do
    news = News.create(:firm_id => 1, :title => "test")
    news.permalink.should eq "test"
    news1 = News.create(:firm_id => 1, :title => "test")
    news1.permalink.should eq "test-" + Time.now.to_s(:db).parameterize
  end
  
  it 'states' do
    n = News.new(:firm_id => 1, :title => "wow..")
    n.state.should eq "На модерации"
  end
  
  
  it 'cache' do
    10.times do |i|
      News.create(:firm_id => 1, :state_id => 1,  :title => "news-#{i}")
    end
    
    News.cached_latest_news.should have(5).records    
    News.last.update_attribute :state_id, 2
    Rails.cache.fetch("site/#{Settings.site_id}/latest_news").should be_nil
    
    News.cached_latest_news.should have(5).records
    News.last.destroy
    Rails.cache.fetch("site/#{Settings.site_id}/latest_news").should be_nil
  end
end
