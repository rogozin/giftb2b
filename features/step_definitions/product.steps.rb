Given /^I visit the "([^"]*)" category page$/  do |arg1|
  @product = Factory(arg1)
  visit category_path(@product.categories.first)
end


