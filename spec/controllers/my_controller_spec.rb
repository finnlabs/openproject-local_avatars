require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MyController do
  it_should_behave_like "a controller with avatar features"
  
  describe "GET /my/avatar" do
    let(:user) { user_without_avatar }
    before{ User.stub!(:current).and_return user }
    let(:do_action) { get 'avatar' }
    it { do_action; assigns(:user).should == user }
    it { do_action; should render_template 'my/avatar' }
  end
  
  describe "GET /my/avatar/update" do
    before{ user.save; User.stub!(:current).and_return user }
    describe "WHEN save submit" do
      let(:submit_param) { {:commit => :button_save, :avatar => avatar_file} }
      describe "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        describe "WHEN save is successful" do
          it { do_action; response.should be_redirect }
          it { do_action; should redirect_to my_account_path }
          specify { user.should_receive(:local_avatar_attachment=); do_action }
          it { do_action; flash[:notice].should include_text "changed" }
        end        
        describe "WHEN save is not successful" do
          before { user.stub!(:local_avatar_attachment=).and_raise(RuntimeError) }
          it { do_action; response.should be_redirect }
          it { do_action; should redirect_to my_avatar_path }
          it { do_action; flash[:notice].should be_blank }
          it { do_action; flash[:error].should include_text "could not be saved"}
        end
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to my_account_path }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "changed" }
      end
    end

    describe "WHEN delete submit" do
      let(:submit_param) { {:delete => :true} }
      describe "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to my_avatar_path }
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:error].should include_text "could not be deleted" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param }
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to my_account_path }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "deleted successfully" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end
    end
  end
end