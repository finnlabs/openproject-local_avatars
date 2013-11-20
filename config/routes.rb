OpenProject::Application.routes.draw do

  post 'my/avatar', :controller => 'my', :action => 'update_avatar'

  get 'my/avatar', :controller => 'my', :action => 'avatar'

  get 'users/:id/avatar', :controller => 'users', :action => 'dump_avatar'

  post 'users/:id/avatar', :controller => 'users', :action => 'update_avatar'

end