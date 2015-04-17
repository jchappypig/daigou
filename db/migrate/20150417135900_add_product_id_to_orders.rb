class AddProductIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :product_id, :integer
    add_index :orders, :product_id
  end
end
