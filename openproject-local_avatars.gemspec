# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/local_avatars/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-local_avatars"
  s.version     = OpenProject::LocalAvatars::VERSION
  s.authors     = "Finn GmbH"
  s.email       = "info@finn.de"
  s.homepage    = "https://www.openproject.org/projects/local-avatars"
  s.summary     = 'OpenProject Local Avatars'
  s.description = 'This plugin allows OpenProject users to upload a picture to be used as
                    an avatar (instead of depending on images from Gravatar).'
  s.license     = 'GPLv3'

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "rmagick", "~> 2.13.2"
end
