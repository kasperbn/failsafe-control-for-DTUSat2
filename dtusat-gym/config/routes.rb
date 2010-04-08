ActionController::Routing::Routes.draw do |map|

	map.logout '/sessions/logout', :controller => 'sessions', :action => "destroy"

	map.export '/observations/export', :controller => 'observations', :action => 'export'

  map.resources :users
  map.resources :sessions
  map.resources :observations

  map.root :controller => 'sessions', :action => 'new'

	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
