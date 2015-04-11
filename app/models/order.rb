class Order < ActiveRecord::Base
  belongs_to :casein_admin_user, class_name: Casein::AdminUser

  validates :name, presence: true
  validates :amount, presence: true

  STATUS = [I18n.t('status.new'), I18n.t('status.posted')]

  scope :active, -> { where(cancelled: false) }
  scope :posted, ->(posted)  do
    if posted.nil?
      Order.all.order(created_at: :desc)
    elsif posted.downcase == 'true'
      where('status = ? OR status = ?', Order.get_all_posted_values.first, Order.get_all_posted_values.last)
    else
      where.not('status = ? OR status = ?', Order.get_all_posted_values.first, Order.get_all_posted_values.last).active.order(:casein_admin_user_id)
    end
  end

  def is_posted?
    posted_values = Order.get_all_posted_values

    return posted_values.include?(status)
  end

  def self.get_all_posted_values
    posted_values = []
    [:en, :'zh-CN'].each do |locale|
      posted_values << I18n.with_locale(locale) { I18n.t('status.posted') }
    end
    posted_values
  end
end