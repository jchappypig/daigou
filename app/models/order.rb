class Order < ActiveRecord::Base
  belongs_to :casein_admin_user, class_name: Casein::AdminUser

  STATUS = [I18n.t('status.new'), I18n.t('status.posted')]

  scope :active, -> { where(cancelled: false) }

  def is_posted?
    posted_values = []
    [:en, :'zh-CN'].each do |locale|
      posted_values << I18n.with_locale(locale){I18n.t('status.posted')}
    end

    return posted_values.include?(status)
  end
end