#encoding: utf-8;
module Gift
  module Export
    module Excel
      def export_commercial_offer_with_pictures(commercial_offer)
         xls_stream = StringIO.new('')
         workbook = WriteExcel.new(xls_stream)
         worksheet  = workbook.add_worksheet()
         header  = workbook.add_format(:bold => 1, :size => 18)
         format1 = workbook.add_format()
         format1.set_text_wrap()
         format1.set_align('vcenter')
         
         worksheet.insert_image(0,0, commercial_offer.firm.logo.path(:thumb)) if commercial_offer.firm.logo
         worksheet.write(0, 2, commercial_offer.firm.short_name )  
         worksheet.set_row(0,85)
         worksheet.write_row 1,0, [["Адрес:", "Менеджер:", "Тел/факс:", "e-mail:", "веб-сайт:", "Специально для:"],
        [commercial_offer.firm.addr_f, commercial_offer.user.fio, commercial_offer.firm.phone, commercial_offer.firm.email, commercial_offer.firm.url, commercial_offer.lk_firm ? commercial_offer.lk_firm.name : ""]]
         bold = workbook.add_format(:bold => 1)
         
         worksheet.write_row(7,2,["Артикул","Название товара","Цена","Кол-во","Сумма","Материал","Цвет","Размер", "Упаковка", "Нанесение", "Склад", "Описание"], bold)    
         @index = 0
         commercial_offer.commercial_offer_items.each_with_index do |i, index|
           worksheet.set_row(8+index, 100)
           worksheet.insert_image(8 + index, 0, i.lk_product.picture.path(:thumb))
           worksheet.write_row(8 + index, 2, [i.lk_product.article, i.lk_product.short_name, i.lk_product.price, i.quantity, i.quantity * i.lk_product.price, i.lk_product.factur, i.lk_product.color, i.lk_product.size, i.lk_product.box, i.lk_product.infliction, i.lk_product.store_count, i.lk_product.description],format1)
           @index = index
         end
         worksheet.write(9 + @index, 0, commercial_offer.signature )
         workbook.close
         xls_stream.string
      end  
    end
  end
end
