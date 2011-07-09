require 'config/boot'
require 'config/environment'

every(1.minute, 'test') { puts Product.all.size }
