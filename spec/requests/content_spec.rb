#encoding: utf-8;
describe 'Контент' do
  #замороженный контент может редактировать только администратор

  context 'админка' do
    it 'Список страниц' do
      visit admin_content_path
      page.shoul have_content "Управление контентом"
    end
  end

  it 'Добавление контента' do
    
  end

  it 'Предпросмотр контента' do
    
  end

  it 'добавление картинок к контенту' do
    
  end
  
end
