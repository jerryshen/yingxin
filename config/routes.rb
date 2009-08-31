ActionController::Routing::Routes.draw do |map|
  map.resources :step8s

  map.resources :fee_temps, :collection => { :ensure_fee => :post}

  map.resources :green_paths

  map.resources :bed_autodists

  map.resources :beds

  map.resources :complexes, :collection => { :export_no_fee => :get, :export_confirm_true => :get, :export_no_signup => :get}

  map.resources :stats, :collection => {:export_all => :get, :export => :get}
  map.resources :temps
  map.resources :proces
  map.resources :step7s
  map.resources :step6s
  map.resources :step5s
  map.resources :step4s
  map.resources :step3s
  map.resources :step2s
  map.resources :step1s
  map.resources :fee_stds
  map.resources :subjects
  map.resources :tips

  map.resources :students
  map.resources :rooms
  map.resources :buildings
  map.resources :info_classes, :collection => { :selector => :get}
  map.resources :majors
  map.resources :app_configs
  map.resources :role_users
  map.resources :users, :collection => { :change_my_password => :get, :my_profile=> :get }
  map.resources :departments do |departments|
    departments.resources :users
    departments.resources :majors
  end
  map.resources :page_roles
  map.resources :roles
  map.resources :pages
  map.resources :page_modules

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect '/departments/users_to_json', :controller => "departments", :action => "users_to_json"
  map.root :controller => 'admin', :action => 'index'
  map.connect ':controller/:action', :controller => ['admin','bed_assigning','buildings']
  map.connect '/dispatch', :controller => "students", :action => "dispatch"
  map.connect '/do_dispatch', :controller => "students", :action => "do_dispatch"
  map.connect '/logout', :controller => 'admin', :action => 'logout'
  map.connect '/signin', :controller => 'admin', :action => 'login'
  map.connect '/welcome', :controller => "welcome"
  map.connect '/genarate_room', :controller => "buildings", :action => "genarate_room"

  map.connect '/major/:major_id/students:print', :controller => "students", :action => "print"
  map.connect '/students:print', :controller => "students", :action => "print"
  map.connect '/baodaodan/:id', :controller => "step1s", :action => "baodao"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
