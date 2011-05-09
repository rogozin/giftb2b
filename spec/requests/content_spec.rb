#encoding: utf-8;
describe 'Контент' do
  #замороженный контент может редактировать только администратор

  context 'админка' do
    it 'Список страниц' do
      visit admin_content_path
      page.shoul have_content "Управление контентом"
    end
  end
  
end
