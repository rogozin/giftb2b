SitemapGenerator::Sitemap.default_host = "http://giftb2b.ru"
SitemapGenerator::Sitemap.filename = "sitemap-fd382dq4adbd5fl"

SitemapGenerator::Sitemap.create do 
#    Category.active.each do |category|
#      add category_path(category), :lastmod => category.updated_at
#    end
  
    News.active.each do |news|
      add news_path(news), :lastmod => news.updated_at,:priority => 0.7
    end    
  
    Content.all.each do |page|
      add content_path(page), :lastmod => page.updated_at, :priority => 0.3
    end
    
    Firm.where_city_present.each do |firm|
     add firm_path(firm.permalink), :lastmod => firm.updated_at, :priority => 0.4
    end
  
    dayly_suppliers = [1,2,4,5,28,29,31,37,39,40,47,49,51,52]
  
    Product.find_each do |product|
      add product_path(product), :lastmod => product.updated_at, :changefreq => dayly_suppliers.include?(product.supplier_id) ? 'dayly' : 'weekly', :priority => 0.6
    end
end
