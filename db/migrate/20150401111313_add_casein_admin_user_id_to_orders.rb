class AddCaseinAdminUserIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :casein_admin_user, index: true, foreign_key: true
  end
end
