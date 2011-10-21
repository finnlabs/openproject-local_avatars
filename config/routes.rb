ActionController::Routing::Routes.draw do |map|
  map.update_my_avatar 'my/avatar', :controller => 'my', :action => 'update_avatar', :conditions => { :method => :post }
  map.my_avatar 'my/avatar', :controller => 'my', :action => 'avatar', :conditions => { :method => :get }
  map.dump_user_avatar 'users/:id/avatar', :controller => 'users', :action => 'dump_avatar', :conditions => { :method => :get }
  map.update_user_avatar 'users/:id/avatar', :controller => 'users', :action => 'update_avatar', :conditions => { :method => :post }
end