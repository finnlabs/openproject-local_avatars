# Redmine Local Avatars plugin
#
# Copyright (C) 2010  Andrew Chaika, Luca Pireddu
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'
require 'dispatcher'
require 'chiliproject_local_avatars/local_avatars'

Dispatcher.to_prepare(:chiliproject_local_avatars) do
	require_dependency 'principal'
	require_dependency 'user'
	require_dependency 'my_controller'
	require_dependency 'users_controller'

  ApplicationHelper.send(:include, ChiliprojectLocalAvatars::ApplicationHelperPatch)
  [MyController, UsersController, User, UsersHelper].each do |base|
    patch = "ChiliprojectLocalAvatars::#{base.name}Patch".constantize
    base.send(:include, patch) unless base.included_modules.include?(patch)
  end
end

Redmine::Plugin.register :chiliproject_local_avatars do
  name 'Chiliproject Local Avatars plugin'
  author 'Andrew Chaika, Luca Pireddu; Stephan Eckardt @ Finnlabs'
  description 'This plugin lets users upload avatars directly into Chiliproject'
	version '0.2.0'

  add_menu_item :my_menu, :change_avatar, {:controller => 'my', :action => 'avatar'}, :caption => :button_change_avatar
end