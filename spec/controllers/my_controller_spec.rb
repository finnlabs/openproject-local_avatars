require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../shared_examples')

describe MyController do
  include_examples "a controller with avatar features"

  describe "GET /my/avatar" do
    let(:user) { user_without_avatar }
    before{ User.stub!(:current).and_return user }
    let(:do_action) { get 'avatar' }
    it { do_action; assigns(:user).should == user }
    it { do_action; should render_template 'my/avatar' }
  end

  describe "GET /my/avatar/update" do
    before{ user.save; User.stub!(:current).and_return user }
    context "WHEN save submit" do
      let(:submit_param) { {:commit => :button_save, :avatar => avatar_file} }
      context "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        context "WHEN save is successful" do
          it { do_action; response.should be_redirect }
          it { do_action; should redirect_to({ :controller => "my", :action => "account" }) }
          specify { user.should_receive(:local_avatar_attachment=); do_action }
          it { do_action; flash[:notice].should include "changed" }
        end
        context "WHEN save is not successful" do
          before { user.stub!(:local_avatar_attachment=).and_raise(RuntimeError) }
          it { do_action; response.should be_redirect }
          it { do_action; should redirect_to my_avatar_path }
          it { do_action; flash[:error].should include "Error"}
        end
      end

      context "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to({ :controller => "my", :action => "account" }) }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include "changed" }
      end
    end

    describe "WHEN delete submit" do
      let(:submit_param) { {:delete => :true} }
      context "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to my_avatar_path }
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:error].should include "could not be deleted" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end

      context "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to({ :controller => "my", :action => "account" }) }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include "deleted successfully" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end
    end
  end
end
