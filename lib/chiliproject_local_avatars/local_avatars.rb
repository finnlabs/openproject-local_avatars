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

module ChiliprojectLocalAvatars
	module LocalAvatars
	  private
		# expects @user to be set.
		# In case of error, raises an exception and sets @possible_error

		def save_or_delete_avatar
			if params[:delete]
  			attachment = @user.local_avatar_attachment
  			attachment.destroy if attachment
        if @user.save
    			flash[:notice] = l(:avatar_deleted)
        else
          false
        end
      else
  			old_attachment = @user.local_avatar_attachment
        ok = begin
               @user.local_avatar_attachment = params[:avatar]
               old_attachment.destroy if old_attachment
               true
             rescue
               false
             end
  			if ok and @user.save
    			flash[:notice] = l(:message_avatar_uploaded)
  			else
  			  flash[:error] = l(:error_saving_avatar)
  			  false
  		  end
      end
		end
	end
end
