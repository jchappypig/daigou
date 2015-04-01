class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :name
      t.integer :amount
      t.boolean :has_paid
      t.string :status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end