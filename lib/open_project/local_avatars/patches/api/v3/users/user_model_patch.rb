module OpenProject::LocalAvatars
  module Patches
    module API
      module V3
        module Users
          module UserModelPatch
            def self.included(base) # :nodoc:
              base.class_eval do
                def local_avatar_attachment
                  model.local_avatar_attachment if model.respond_to?(:local_avatar_attachment) # groups do not respond to that
                end
              end
            end
          end
        end
      end
    end
  end
end
