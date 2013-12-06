When /^I upload a "(.*?)" image/ do |image|
  attach_file(:avatar, File.join(File.dirname(__FILE__), '../upload-files', image.to_s))
end
