class AddAddressPhoneToAdminUser < ActiveRecord::Migration
  def change
    add_column :casein_admin_users, :address, :text
    add_column :casein_admin_users, :phone, :string
  end
end
