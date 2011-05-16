#encoding: utf-8;
require 'spec_helper'
describe 'Контент' do
  #замороженный контент может редактировать только администратор

  context 'в админке' do
    before(:each) do
       login_as :content_editor
    end    

    it 'Список страниц' do
      visit admin_contents_path
      page.should have_content "Управление контентом"
    end
  end

  it 'Добавление контента' do
    
  end

  it 'Предпросмотр контента' do
    
  end

  it 'добавление картинок к контенту' do
    
  end

  context 'на сайте ' do
    before(:each) do
      @content_category = Factory(:content_category)      
      @content = Factory(:content, :content_category => @content_category)
    end    

    it 'я вижу опубликованную новость' do
      visit content_path(@content)
      within ".page_content" do
        page.should have_content @content.title
        page.should have_content @content.body
      end
    end

    it 'я не вижу черновик' do
      @content.toggle! :draft
      visit content_path(@content)
      page.should have_no_content @content.body
      page.should have_content "не существует"
      visit content_category_path(@content_category)
      #save_and_open_page
      within ".content_category" do
        page.should have_no_content @content.title  
      end
    end

    it 'я не вижу страницы у которых дата публикации не наступила' do
      @content.update_attribute :start, Date.tomorrow
      visit content_path(@content)
      page.should have_no_content @content.body
      page.should have_content "не существует"
      visit content_category_path(@content_category)
      within ".content_category" do
        page.should have_no_content @content.title  
      end
    end

    it 'я не вижу страницу с законченным сроком действия' do
      @content.update_attribute :stop, Date.yesterday
      visit content_path(@content)
      page.should have_no_content @content.body
      page.should have_content "не существует"
      visit content_category_path(@content_category)
      within ".content_category" do
        page.should have_no_content @content.title  
      end
    end

    it 'постраничная навигация по 10 элементов в категории' do
      20.times do
        Factory(:content, :content_category => @content_category)
      end      
      visit content_category_path(@content_category)
       
      within "#main_content" do
        page.should have_css(".content_title", :count => 10)
        click_link "Вперед"
        page.should have_css(".content_title", :count => 10)
      end
    end
  end
  
end
