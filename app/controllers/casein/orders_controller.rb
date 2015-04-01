# Scaffolding generated by Casein v5.1.1.5

module Casein
  class OrdersController < Casein::CaseinController
  
    ## optional filters for defining usage according to Casein::AdminUser access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
      @casein_page_title = 'Orders'
  		@orders = Order.order(sort_order(:created_at)).paginate :page => params[:page]
    end
  
    def show
      @casein_page_title = 'View order'
      @order = Order.find params[:id]
    end
  
    def new
      @casein_page_title = 'Add a new order'
    	@order = Order.new
    end

    def create
      @order = Order.new order_params
    
      if @order.save
        flash[:notice] = 'Order created'
        redirect_to casein_orders_path
      else
        flash.now[:warning] = 'There were problems when trying to create a new order'
        render :action => :new
      end
    end
  
    def update
      @casein_page_title = 'Update order'
      
      @order = Order.find params[:id]
    
      if @order.update_attributes order_params
        flash[:notice] = 'Order has been updated'
        redirect_to casein_orders_path
      else
        flash.now[:warning] = 'There were problems when trying to update this order'
        render :action => :show
      end
    end
 
    def destroy
      @order = Order.find params[:id]

      @order.destroy
      flash[:notice] = 'Order has been deleted'
      redirect_to casein_orders_path
    end
  
    private
      
      def order_params
        params.require(:order).permit(:name, :amount, :has_paid, :status)
      end

  end
end