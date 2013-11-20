# OpenProject Local Avatars plugin
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

module OpenProject::LocalAvatars
  module Patches
    module ApplicationHelperPatch
      def self.included(base) # :nodoc:
        base.class_eval do

          def avatar_with_local(user, options = {})
            local_avatar(user, options) || avatar_without_local(user, options)
          end

          def local_avatar(user, options = {})
            if user.is_a?(User) then
              av = user.local_avatar_attachment
              if av then
                image_url = url_for :only_path => false, :controller => 'users', :action => 'dump_avatar', :id => user
                options[:size] = "64" unless options[:size]
                return "<img class=\"gravatar\" width=\"#{options[:size]}\" height=\"#{options[:size]}\" src=\"#{image_url}\" />"
              end
            end
            nil
          end

          alias_method :avatar, :avatar_with_local
          alias_method :avatar_without_local, :avatar unless method_defined?(:avatar_without_local)
          # UGLYHAX patching ApplicationHelper is evil
        end
      end
    end
  end
end