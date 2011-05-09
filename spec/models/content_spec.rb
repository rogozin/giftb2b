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
     Factory(:content)
     Factory(:content, :draft => true)
     Factory(:content, :stop => Date.yesterday)
     Factory(:content, :start => Date.tomorrow)
     Content.active.should have(1).records 
    end

  end

end
