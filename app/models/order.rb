class Order < ActiveRecord::Base
  belongs_to :casein_admin_user, class_name: Casein::AdminUser

  STATUS = [I18n.t('status.new'), I18n.t('status.posted')]
end