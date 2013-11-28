ENV["RAILS_ENV"] ||= "test"
require 'spec_helper'

require File.dirname(__FILE__) + "/plugin_spec_helper"

#require 'redmine_factory_girl'

# prevent case where we are using rubygems and test-unit 2.x is installed
#begin
#  require 'rubygems'
#  gem "test-unit", "~> 1.2.3"
#rescue LoadError
#end
#
#begin
#  #require "config/environment" unless defined? RAILS_ROOT
#
#rescue LoadError => error
#  puts <<-EOS
#
#    You need to install rspec in your ChiliProject project.
#    Please execute the following code:
#
#      gem install rspec-rails
#      script/generate rspec
#
#  EOS
#  raise error
#end