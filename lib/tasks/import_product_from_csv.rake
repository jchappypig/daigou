require 'spreadsheet'

desc 'import the products'
namespace :db do
  task :import_products => :environment do
    def import_products
      Spreadsheet.client_encoding = 'UTF-8'
      file = Spreadsheet.open 'lib/products.xls'
      worksheet = file.worksheet 0

      worksheet.each do |row|
        if row[1].present?
          product = Product.new
          product.name = row[0]
          product.category = row[1]
          product.save
        end
      end

      puts 'Products import completed!'
    end

    import_products
  end
end