require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MyController do
  let(:user) { u = Factory.create :user; u.stub!(:id).and_return 123; u }
  before do
    user
    User.stub!(:current).and_return user
    File.stub!(:delete).and_return true
  end
  
  describe "GET /my/avatar" do
    let(:do_action) { get 'avatar' }
    it { do_action; assigns(:user).should == user }
    it { do_action; should render_template 'my/avatar' }
  end
end