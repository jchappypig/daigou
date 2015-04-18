require 'spreadsheet'

desc 'update the products'
namespace :db do
  task :update_products => :environment do
    def update_products
      products = Product.with_name('BM-')
      products.each do |product|
        name = product.name
        product.name = name.sub('BM-', 'Blackmores-')
        product.save
      end

      products = Product.with_name('HC')
      products.each do |product|
        name = product.name
        product.name = name.sub('HC', 'Health Care')
        product.save
      end

      puts 'Products update completed!'
    end

    update_products
  end
end