Rails.application.routes.draw do

  namespace :casein do
  get 'errors/file_not_found'
  end

  namespace :casein do
  get 'errors/unprocessable'
  end

  namespace :casein do
  get 'errors/internal_server_error'
  end

	#Casein routes
	namespace :casein do
		resources :orders do
      post '/' => 'orders#cancel'
    end

    resources :admin_users do
      collection do
        get 'sign_up' => 'admin_users#sign_up'
        post 'sign_up' => 'admin_users#create_after_sign_up'
      end
    end
	end

  root 'casein/orders#index'

  match '/404', to: 'casein/errors#file_not_found', via: :all
  match '/422', to: 'casein/errors#unprocessable', via: :all
  match '/500', to: 'casein/errors#internal_server_error', via: :all

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
