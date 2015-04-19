module Casein
  
  class CaseinNotification < ActionMailer::Base
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'casein')
	
  	def generate_new_password(from, casein_admin_user, host, pass)
      basic_setup(casein_admin_user, host)
      @pass = pass

      mail(:to => casein_admin_user.email, :from => from, :subject => "[#{casein_config_website_name}] #{I18n.t('title.reset_password')}")
    end
  
  	def new_user_information(from, casein_admin_user, host, pass)
      basic_setup(casein_admin_user, host)
      @pass = pass

      mail(:to => casein_admin_user.email, :from => from, :subject => "[#{casein_config_website_name}] #{I18n.t('title.new_user')}")
    end

		def password_reset_instructions(from, casein_admin_user, host)
      basic_setup(casein_admin_user, host)
      ActionMailer::Base.default_url_options[:host] = host.gsub('http://', '')
      @reset_password_url = edit_casein_password_reset_url + "/?token=#{casein_admin_user.perishable_token}"

      mail(:to => casein_admin_user.email, :from => from, :subject => "[#{casein_config_website_name}] #{I18n.t('title.reset_password_instructions')}")
    end

    def new_order_information(from, casein_admin_user, host, order)
      basic_setup(casein_admin_user, host)
    end

    def order_posted_information(from, casein_admin_user, host, order)
      basic_setup(casein_admin_user, host)
      ActionMailer::Base.default_url_options[:host] = host.gsub('http://', '')
      @order_url = casein_order_url(order)
      @bought_date = order.created_at.strftime('%x')
      @product_name = order.product_name

      mail(:to => casein_admin_user.email, :from => from, :subject => "[#{casein_config_website_name}] #{I18n.t('title.order_posted')}")
    end

    private

    def basic_setup(casein_admin_user, host)
      @name = casein_admin_user.name
      @host = host
      @login = casein_admin_user.login
      @from_text = casein_config_website_name
    end
  end
end