Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/", to: "home#index", as: :home
  # Define a resourceful route for products
  # This will create routes for index, show, new, create, edit, update, destroy actions
  # For example, products_path will point to the index action, and product_path(:id) will point to the show action
  # You can also use resources :products, only: [:index, :show] if you want to limit the routes created
  # resources :products, only: [:index, :show]
  # If you want to create a custom route for products, you can do so like this:
  # get "products", to: "products#index"
  # get "products/:id", to: "products#show", as: :product
  # This will create a route for products#index at /products and products#show at /products/:id
  # You can also use resources :products to create all RESTful routes for products
  # This will create routes for index, show, new, create, edit, update, destroy actions
  # For example, products_path will point to the index action, and product_path(:id) will point to the show action
  # You can also use resources :products, only: [:index, :show] if you want to limit the routes created
  # resources :products, only: [:index, :show]
  # If you want to create a custom route for products, you can do so like this
  # get "products", to: "products#index"
  # get "products/:id", to: "products#show", as: :product
  # This will create a route for products#index at /products and products#show at /products/:id
  resources :products
  
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
