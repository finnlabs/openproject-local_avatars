OpenProject::Application.routes.draw do

  post 'my/avatar', :controller => 'my', :action => 'update_avatar', :as => :update_my_avatar

  get 'my/avatar', :controller => 'my', :action => 'avatar', :as => :my_avatar

  get 'users/:id/avatar', :controller => 'users', :action => 'dump_avatar', :as => :dump_user_avatar

  post 'users/:id/avatar', :controller => 'users', :action => 'update_avatar', :as => :update_user_avatar

end