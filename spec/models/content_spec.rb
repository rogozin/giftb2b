require 'spec_helper'


describe Content do
  subject {Content.new}
  it {should have(1).error_on(:title)}
  it 'Зпголовок имеет не более 255 сиволов' do
    name = gen_content(256)
    should have(1).error_on(:title)
  end

  context 'permalink' do
    before(:each) do
      @content =Content.new      
    end

    it 'Дата окончания не может быть больше даты начала' do
      @content.start = Time.now + 1.hour
      @content.stop = Time.now
      @content.save
      @content.should have(1).error_on(:stop)
    end

    it 'permalink создается автоматически' do
      @content.title = "test"
      @content.save
      @content.permalink.should == @content.title 
    end

    it 'permalink имеет ограничение в 255 сиволов' do
      @content.permalink = gen_content(256)
      @content. should have(1).error_on(:permalink)      
    end
  end

  context 'associations' do
    
    it 'active' do
     @cc = Factory(:content_category)
     @c1 = Factory(:content, :content_category => @cc)
     @c2 = Factory(:content, :content_category => @cc, :draft => true)
     @c3 = Factory(:content, :content_category => @cc, :stop => Date.yesterday)
     @c4 = Factory(:content, :content_category => @cc, :start => Date.tomorrow)
     Content.active.should have(1).records  
     @cc.contents.should have(4).records
     @cc.active_pages.should have(1).records
     @c1.should be_active
     @c2.should_not be_active 
     @c3.should_not be_active 
     @c3.should_not be_active 
    end

        

  end

end
