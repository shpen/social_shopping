Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations", passwords: 'users/passwords' }
  get 'users' => 'users#index'
  get 'users/:id' => 'users#show', as: :user
  get 'users/facebook_permissions' => 'users#facebook_permissions', as: :facebook_permissions

  get 'friends' => 'friends#index'
  post 'users/:id/friend_request' => 'friends#request_friend', as: :friend_request
  put  'friend_requests/:id/accept' => 'friends#accept', as: :friend_accept
  delete 'friend_requests/:id/decline' => 'friends#decline', as: :friend_decline
  delete 'friends/:id/delete' => 'friends#delete', as: :friend_delete
  get 'friends/facebook' => 'friends#facebook', as: :facebook_friends
  post 'friends/facebook' => 'friends#facebook_add', as: :facebook_friends_add

  get 'vote' => 'votes#vote', as: :vote

  resources :questions do
    resources :answers, except: :index

    get :autocomplete_tag_name, on: :collection
  end

  resources :comments, except: :index
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
