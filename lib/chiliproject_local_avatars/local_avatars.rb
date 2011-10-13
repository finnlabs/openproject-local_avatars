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
		def send_avatar(user)
			av = user.attachments.find_by_description 'avatar'
      unless av
        render_404
      else
  		  send_file(av.diskfile, :filename => filename_for_content_disposition(av.filename),
  			                       :type => av.content_type, 
  			                       :disposition => (av.image? ? 'inline' : 'attachment'))
      end
    end
		# expects @user to be set.
		# In case of error, raises an exception and sets @possible_error

		def save_or_delete_avatar
			if params[:commit] == l(:button_delete)
        delete_avatar
      else
        save_avatar
      end
		end
		
		def save_avatar
      remove_avatar_attachment
			Attachment.attach_files(@user, {'first' => {'file' => params[:avatar], 'description' => 'avatar'}})
			if @user.save
  			flash[:notice] = l(:message_avatar_uploaded)
			else
			  flash[:error] = l(:error_saving_avatar)
			  false
		  end
	  end
		
		def delete_avatar
      remove_avatar_attachment
      if @user.save
  			flash[:notice] = l(:avatar_deleted)
      else
        false
      end
	  end
	  
	  def remove_avatar_attachment
			attachment = @user.attachments.find_by_description('avatar')
			attachment.destroy if attachment
    end
	end
end
