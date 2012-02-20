#encoding: utf-8;
namespace :export do
  desc "Export all active products with price > 0 to tmp/csvexport directory in csv format"  
  task :csv => :environment do
    Export::Csv.export
  end
end
