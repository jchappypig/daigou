class Order < ActiveRecord::Base
  belongs_to :casein_admin_user, class_name: Casein::AdminUser
  belongs_to :product

  validates :amount, presence: true

  validate :product_name_must_be_present

  def product_name_must_be_present
    if !product_name.present?
      errors.add(:product_id, I18n.t('activerecord.errors.models.order.attributes.name.blank'))
    end
  end

  STATUS = [I18n.t('status.new'), I18n.t('status.posted')]

  scope :active, -> { where(cancelled: false) }
  scope :posted, ->(posted) do
    if posted.nil?
      self.all.order(created_at: :desc)
    elsif posted.downcase == 'true'
      where('status = ? OR status = ?', Order.get_all_posted_values.first, Order.get_all_posted_values.last)
    else
      where.not('status = ? OR status = ?', Order.get_all_posted_values.first, Order.get_all_posted_values.last).active.order(:casein_admin_user_id)
    end
  end

  scope :needs_product_input, ->(needs_product_input = true) do
    needs_product_input ?  where(product_id: nil).order(:name) : self.all
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

  def product_name
    (product && product.name) || name
  end
end