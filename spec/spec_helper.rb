require 'spec_helper'

RSpec.configure do |config|
##  # Mock Framework
##  #config.mock_with :rspec
##
##  # If you're not using ActiveRecord, or you'd prefer not to run each of your
##  # examples within a transaction, remove the following line or assign false
##  # instead of true.
#  config.use_transactional_fixtures = false
##
##  # Render views when testing controllers
##  # This gives us some coverages of views
##  # even when we aren't testing them in isolation
##  #config.render_views
##
#  config.after(:all) do
#    # Get rid of the linked images
#    if Rails.env.test? || Rails.env.cucumber?
#      path = OpenProject::Configuration['attachments_storage_path'] ||
#          Rails.root.join('files').to_s
#
#      FileUtils.rm_r "#{path.to_s}/*", :force => true
#    end
#  end

end
