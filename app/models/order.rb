class Order < ActiveRecord::Base
  belongs_to :casein_admin_user, class_name: Casein::AdminUser
end