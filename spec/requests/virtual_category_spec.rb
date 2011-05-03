require 'spec_helper'

describe "Работа с вирутальной категорией" do 
  context "Поведение виртуальной категории на главной странице" do 
    before(:each) do
      @description = "Это виртуальная категория. Она может объединять в себе неограниченное количество других категорий каталога"
      @virtual_category =  Factory(:category, :kind => 0, :show_description => true, :description => @description )
      @cat1 = Factory(:category, :virtual_id => @virtual_category.id)
    end
    
    context 'Страница виртуальной категории' do
      before(:each) do
        visit "/"
        within "#virtual_catalog" do
          click_link @virtual_category.name      
        end        
      end

      it 'я должен увидеть описание' do
        within "#main_content" do
          page.should have_content @virtual_category.name
          page.should have_content @description
        end        
      end

      it 'я должен увидеть картинку' do
        img = Image.new :picture => File.new(File.join(Rails.root, '/public/images/default_image.jpg'))
        @virtual_category.images<< img
        visit category_path(@virtual_category)
        page.should have_selector "#virtual_image img"
        save_and_open_page
      end
      
      it 'Если описание запрещено к показу, то я его не увижу' do
        @virtual_category.toggle!(:show_description)
        visit category_path(@virtual_category)
        page.should have_no_content(@description)
      end
      
    end #context
    
  end
end
