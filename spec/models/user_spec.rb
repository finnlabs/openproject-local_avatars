require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  let(:user) { Factory.build :user }
  
  specify { user.attachments.should be_a_kind_of Array }
end