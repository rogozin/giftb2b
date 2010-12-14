# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Giftr3::Application.initialize!
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&laquo; Назад'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Вперед &raquo;'
