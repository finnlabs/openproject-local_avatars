When /^I upload a "(.*?)" image/ do |image|
  attach_file(:avatar, File.join(File.dirname(__FILE__), '../upload-files', image.to_s))
end

Given /^I am logged in with user "(.*?)" that has an avatar/ do | login |
  user = User.find_by_login(login)
  user.attachments = [FactoryGirl.build(:avatar_attachment, :author => user)]
  page.set_rack_session(:user_id => user.id)
end

Then /^I should see local avatar inside "(.*?)"/ do |container|
  page.should have_xpath('//div[@class="' + container.to_s + '"]/img[@class="gravatar"]')
end
