require 'securerandom'

module Casein
  class AdminUsersController < Casein::CaseinController

    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @casein_page_title = t('menu.users')
      @users = Casein::AdminUser.order(sort_order(:login)).paginate :page => params[:page]
    end
 
    def new
      @casein_page_title = t('action.create_user')
    	@casein_admin_user = Casein::AdminUser.new
    	@casein_admin_user.time_zone = Rails.configuration.time_zone
    end
  
    def create
      generate_random_password if params[:generate_random_password]

      @casein_admin_user = Casein::AdminUser.new casein_admin_user_params
    
      if @casein_admin_user.save
        flash[:notice] = t('message.create_user_success_part1') + @casein_admin_user.name + t('message.create_user_success_part2')
        redirect_to casein_admin_users_path
      else
        flash.now[:warning] = t('message.create_user_fail')
        render :action => :new
      end
    end
  
    def show
    	@casein_admin_user = Casein::AdminUser.find params[:id]
    	@casein_page_title = @casein_admin_user.name + ' > ' + t('action.view_user')
    end
 
    def update
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.name + ' > ' + t('action.view_user')

      if @casein_admin_user.update_attributes casein_admin_user_params
        flash[:notice] = @casein_admin_user.name + t('message.update_user_success')
      else
        flash.now[:warning] = t('message.update_user_fail')
        render :action => :show
        return
      end
      
      if @session_user.is_admin?
        redirect_to casein_admin_users_path
      else
        redirect_to :controller => :casein, :action => :index
      end
    end
 
    def update_password
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.name + ' > ' + t('action.reset_password')
       
      if @casein_admin_user.valid_password? params[:form_current_password]
        if params[:casein_admin_user][:password].blank? && params[:casein_admin_user][:password_confirmation].blank?
          flash[:warning] = t('message.new_password_required')
        elsif @casein_admin_user.update_attributes casein_admin_user_params
          flash[:notice] = t('message.update_password_success')
        else
          flash[:warning] = t('message.update_password_fail')
        end
      else
        flash[:warning] = t('message.current_password_incorrect')
      end
      
      redirect_to :action => :show
    end
 
    def reset_password
      @casein_admin_user = Casein::AdminUser.find params[:id]
      @casein_page_title = @casein_admin_user.name + ' > ' + t('action.reset_password')
       
      if params[:generate_random_password].blank? && params[:casein_admin_user][:password].blank? && params[:casein_admin_user][:password_confirmation].blank?
        flash[:warning] = t('message.new_password_required')
      else
        generate_random_password if params[:generate_random_password]
        @casein_admin_user.notify_of_new_password = true unless (@casein_admin_user.id == @session_user.id && params[:generate_random_password].blank?)

        if @casein_admin_user.update_attributes casein_admin_user_params
          unless @casein_admin_user.notify_of_new_password
            flash[:notice] = t('message.update_password_success')
          else    
            flash[:notice] = t('message.update_password_success')
          end
        else
          flash[:warning] = t('message.current_password_incorrect')
        end
      end

      redirect_to :action => :show
    end
 
    def destroy
      user = Casein::AdminUser.find params[:id]
      if user.is_admin? == false || Casein::AdminUser.has_more_than_one_admin
        user.destroy
        flash[:notice] = user.name + t('message.has_been_deleted')
      end
      redirect_to casein_admin_users_path
    end

    private

      def generate_random_password
        random_password = random_string = SecureRandom.hex
        params[:casein_admin_user] = Hash.new if params[:casein_admin_user].blank?
        params[:casein_admin_user].merge! ({:password => random_password, :password_confirmation => random_password})
      end

      def casein_admin_user_params
        params.require(:casein_admin_user).permit(:login, :name, :email, :phone, :address, :time_zone, :access_level, :password, :password_confirmation)
      end
 
  end
end