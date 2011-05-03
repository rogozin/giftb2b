requirerequire 'spec_helper'

describe "Работа с вирутальной категорией" do 
  context "Поведение виртуальной категории на главной странице" do 
    before(:each) do
      @description = "Это виртуальная категория. Она может объединять в себе неограниченное количество других категорий каталога"
      @virtual_category =  Factory(:category, :kind => 0, :description => @description )
      @cat1 = Factory(:category, :virtual_id => @virtual_category.id)
    end
    
    context 'Страница виртуальной категории' do
      before(:each) do
        visit "/"
        within "#virtual_catalog" do
          click_link @virtual_catalog.name      
        end        
      end

      it 'я должен увидеть описание' do
        within "#main_content" do
          page.should have_content @virtual_catalog.name
          page.should have_content @description
        end        
      end
      
      it 'Если описание запрещено к показу, то я его не увижу' do
        @virtual_category.toggle!(:show_description)
        visit categories_path(@virtual_category)
        page.should have_not_content(@description)
      end
      
    end #context
    
  end
end
