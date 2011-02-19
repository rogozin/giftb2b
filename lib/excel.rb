module Gift
  module Export
    module Excel
      def export_commercial_offer(commercial_offer)
        book = Spreadsheet::Workbook.new
        sheet1 = book.create_worksheet  :name => "Коммерческое предложение"
        sheet1.row(0).push commercial_offer.firm.short_name
        sheet1.row(0).height =20
        sheet1.row(0).set_format(0, Spreadsheet::Format.new(:weight => :bold, :size => 18))
        
        sheet1.row(1).concat ["Адрес:", commercial_offer.firm.addr_f]
        sheet1.row(2).concat ["Менеджер:", commercial_offer.user.fio]
        sheet1.row(3).concat ["Тел/факс:", commercial_offer.firm.phone]
        sheet1.row(4).concat ["e-mail:", commercial_offer.firm.email]
        sheet1.row(5).concat ["веб-сайт:", commercial_offer.firm.url]
        
        format_bold = Spreadsheet::Format.new :weight => :bold
        sheet1.row(7).concat(["Артикул","Название товара","Цена","Кол-во","Сумма","Материал","Цвет","Размер", "Упаковка", "Нанесение"])
        0.upto(9) {|i| sheet1.row(7).set_format(i, format_bold) }

        commercial_offer.commercial_offer_items.each_with_index do |i, index|
          sheet1.row(8+index).concat [ i.lk_product.article, i.lk_product.short_name, i.lk_product.price, i.quantity, i.quantity * i.lk_product.price, i.lk_product.factur, i.lk_product.color, i.lk_product.size, i.lk_product.box, i.lk_product.infliction]        
        end       
        xls_stream = StringIO.new('')
		  	book.write(xls_stream)
		  	xls_stream.string       	
      end   
    end
  end
end
