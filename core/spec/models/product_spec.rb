#encoding: utf-8;
require 'spec_helper'

describe Product do
  before(:each) do
    @currency = CurrencyValue.create({:dt => Date.today, :usd => 30, :eur => 40})
  end
   
  subject { Product.new}
  it { should_not be_valid}
  it {subject.price.should be_zero }
  
  it 'prce' do
    p = Factory(:product, :price => nil)
    p.price.should be_zero
      
  end
#  it { should have(1).error_on(:article)}
#  it { should have(1).error_on(:supplier_id)}


  context 'ruprice' do
    it 'ruprice заполняется автоматически' do
      @product = Factory(:product, :currency_type => "EUR", :price => 10)
      @product.ruprice.should == @currency.eur * @product.price
      @product.update_attributes(:currency_type => "USD")
      @product.ruprice.should == @currency.usd * @product.price
      @product.update_attributes(:currency_type => "RUB")
      @product.ruprice.should == @product.price
    end
    
    it 'у товара в рублях ruprice==price' do
      @product = Factory(:product, :currency_type => "RUB", :price => 10)
      @product.ruprice.should == @product.price      
    end
  end


  context "filtering and searching" do
    before do
      Factory(:product, :short_name => "art12345", :active => false)      
    end
    
    it "active scope should not have inactive products in result" do
      Product.active.should be_empty
    end

    it "should not have inactive product in search result" do
      Product.search("art12345").should be_empty
      Product.search_with_article("art12345").should be_empty
      Product.find_all({:article => "art12345"}).should be_empty
    end
    
    it 'Поиск по производителю' do
      Product.find_all({:manufactor => Manufactor.all.map(&:id)}).should_not be_empty
    end
          
  end
  
  context "sorting" do
    it "products without cost should be at the end of the list" do
      p1 = Factory(:product, :article => "B001", :price => 100, :sort_order => 10)      
      p3 = Factory(:product, :article => "A001", :supplier_id => p1.supplier_id, :price => 0, :sort_order =>20)
      c = Factory(:category, :name => "cat1")
      c.products << [p1, p3]
     search_result = Product.find_all({:page=>1, :per_page=>30, :category=> c.id})
     search_result.last.should == p3
    end
  end


  context 'Цветовые варианты' do
    before(:each) do
      @property = Factory(:color_property)
      @product = Factory(:product)
      @product1= Factory(:product)
      @property.property_values.create(:value => @product1.article )
      @product.property_values << @property.property_values.first
    end
    
    it 'Цветовые варинанты - это хэш' do
      @product.color_variants.should be_a_kind_of(Hash)
      @product.color_variants.should have_key(@property.name)
      @product.color_variants[@property.name].first.should == @product1
    end

    it 'color_variants never retrun unknown article' do
      @property.property_values.create(:value => "not_existed_article" )
      @product.color_variants[@property.name].should have(1).item
    end
  end

  context 'Аналогичные товары' do
    before(:each) do
      5.times { Factory(:product)}
      @analog_category = Factory(:category, :name => "Аналоги", :kind => 1)
      Product.all.each {|p| p.categories << @analog_category}
    end
    
    it 'Аналогичные товары' do
      Product.first.analogs.should have(4).items
      Product.first.analogs.first.should be_a_kind_of(Product)
    end  
  end

   context 'Расширенный поиск' do
     before(:each) do
       @product = Factory(:product, :short_name => "Ручка с брелком")
       @product1 = Factory(:product, :short_name => "Ручка с фонариком")
     end

      it 'Поиск по имени' do
        Product.find_all({:search_text => "Ручка"}).should have(2).item
      end
    
      it 'Поиск по имени - точное совпадение' do
        Product.find_all({:search_text => "Ручка", :eq => "1"}).should be_empty
        Product.find_all({:search_text => "Ручка с брелком", :eq => "1"}).should have(1).item
      end
      
      it 'поиск по категории' do
        
      end
      
     it 'наличие на складе' do
      @product2 = Factory(:product)
      @store1 = Factory(:store, :supplier => @product.supplier)
      @store2 = Factory(:store, :supplier => @product.supplier)
      @store3 = Factory(:store, :supplier => @product.supplier)
      @store4 = Factory(:store, :supplier => @product.supplier)
      @product.store_units.create(:store => @store1, :count => 5)
      @product.store_units.create(:store => @store2, :count => 10)
      @product1.store_units.create(:store => @store3, :count => 20, :option => 0)
      @product2.store_units.create(:store => @store4, :count => 40, :option => -1)
      Product.find_all({:store => 14}).should have(1).record
      Product.find_all({:store => 15, :store_option => []}).should have(1).record
      Product.find_all({:store => 15, :store_option => []}).should have(1).record
      Product.find_all({:store => 15, :store_option => [0]}).should have(2).record
      Product.find_all({:store => 15, :store_option => [-1]}).should have(2).record
    end

   end
  
  context 'Расширенный поиск (цвета и материалы)' do
    before(:each) do
      @material_prop = Factory(:text_property, :name => "Материал")
      @val1 = @material_prop.property_values.create(:value => "Пластик")
      @val2 = @material_prop.property_values.create(:value => "Дерево")

      @color_prop = Factory(:text_property, :name => "Цвет")
      @val3 = @color_prop.property_values.create(:value => "Красный")
      @val4 = @color_prop.property_values.create(:value => "Белый")
      
      @product1  = Factory(:product)
      @product2  = Factory(:product)
      @product3  = Factory(:product)
      @product4  = Factory(:product)
      @product1.product_properties.create(:property_value => @val1)
      @product1.product_properties.create(:property_value => @val2)
      @product1.product_properties.create(:property_value => @val3)
      @product1.product_properties.create(:property_value => @val4)
      
      @product2.product_properties.create(:property_value => @val1)
      @product2.product_properties.create(:property_value => @val2)
      @product2.product_properties.create(:property_value => @val3)
      
      @product3.product_properties.create(:property_value => @val1)
      @product3.product_properties.create(:property_value => @val2)
      
      @product4.product_properties.create(:property_value => @val4)
    end
    
    it 'Передаю пустой параметр' do
      Product.find_all({"property_values_#{@material_prop.id}" => [""]}).should have(4).items      
    end

    it "Ищу по материалу 'Пластик'" do
      Product.find_all({"property_values_#{@material_prop.id}" => ["", @val1.id]}).should have(3).items
    end
    
    it "Ищу по материалу 'Пластик' и цвету 'Красный'" do
      Product.find_all({"property_values_#{@material_prop.id}" => [@val1.id], "property_values_#{@color_prop.id}" => [@val3.id]}).should have(2).items
    end
    
    it "Ищу по материалу 'Пластик' и цвету 'Красный' и 'Белый'" do
      Product.find_all({"property_values_#{@material_prop.id}" => [@val1.id], "property_values_#{@color_prop.id}" => [@val3.id, @val4.id]}).should have(2).items
    end

    it "Ищу по материалу 'Пластик' и 'Дерево' и цвету 'Красный' и 'Белый'" do
      Product.find_all({"property_values_#{@material_prop.id}" => [@val1.id, @val2.id], "property_values_#{@color_prop.id}" => [@val3.id, @val4.id]}).should have(2).items
    end
    
  end
  
end

