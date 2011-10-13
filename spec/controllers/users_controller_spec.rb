require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'ruby-debug'; 

describe UsersController do
  let(:user_without_avatar) { Factory.create :user }
  let(:user_with_avatar) { Factory.create :user_with_avatar }
  before do
    User.stub!(:current).and_return Factory.create(:anonymous)
  end

  describe "GET /users/:id/get_avatar" do
    describe "for a user without an avatar" do
      before do
        User.stub!(:find).with("123").and_return {user_without_avatar}
      end
      let(:do_action) { get :get_avatar, :id => 123}
      it { do_action; response.should_not be_success }
      it { do_action; response.code.should == "404" }
    end
    describe "for an invalid user" do
      let(:do_action) { get :get_avatar, :id => -1}
      it { do_action; response.should_not be_success }
      it { do_action; response.code.should == "404"}
    end
    describe "for a user with an avatar" do
      before do
        User.stub!(:find).with("345").and_return {user_with_avatar}
        @controller.should_receive(:send_file).and_return true
      end
      let(:do_action) { get :get_avatar, :id => 345}
      it { do_action; response.should be_success }
    end
  end
  
  describe "GET /users/:id/update_avatar" do
    before{ User.stub!(:current).and_return Factory.create(:admin) }
    describe "for a user without an avatar" do
    end
  end
end