# Scaffolding generated by Casein v5.1.1.5

module Casein
  class OrdersController < Casein::CaseinController
  
    ## optional filters for defining usage according to Casein::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @casein_page_title = 'Orders'
      if current_user.is_admin?
  		  @orders = Order.all
      else
        @orders = Order.where(casein_admin_user: current_user)
      end

      @orders = @orders.order(sort_order(:created_at)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = t('action.view_order')
      @order = Order.find params[:id]
    end
  
    def new
      @casein_page_title = t('action.create_order')
    	@order = Order.new
    end

    def create
      @order = Order.new order_params
      @order.casein_admin_user = current_user
      @order.status = @order.status ? @order.status : Order::STATUS.first
    
      if @order.save
        flash[:notice] = t('message.create_order_success')
        redirect_to casein_orders_path
      else
        flash.now[:warning] = t('message.create_order_fail')
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = t('action.view_order')
      
      @order = Order.find params[:id]
    
      if @order.update_attributes order_params

        flash[:notice] = t('message.update_order_success')
        redirect_to casein_orders_path
      else
        flash.now[:warning] = t('message.update_order_fail')
        render :action => :show
      end
    end
 
    def destroy
      @order = Order.find params[:id]

      @order.destroy
      flash[:notice] = t('message.delete_order_success')
      redirect_to casein_orders_path
    end

    def cancel
      @order = Order.find params[:order_id]

      @order.cancelled = true
      if @order.save
        flash[:notice] = t('message.cancel_order_success')
        redirect_to casein_orders_path
      else
        flash.now[:warning] = 'There were problems when trying to cancel this order'
        render :action => :index
      end
    end
  
    private
      
      def order_params
        params.require(:order).permit(:name, :amount, :has_paid, :status, :comment)
      end

  end
end