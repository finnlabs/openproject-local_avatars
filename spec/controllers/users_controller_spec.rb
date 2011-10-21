require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  it_should_behave_like "a controller with avatar features"

  describe "GET /users/:id/dump_avatar" do
    before { User.stub!(:current).and_return AnonymousUser.first }
    describe "for an invalid user" do
      let(:do_action) { get :dump_avatar, :id => 0}
      it_should_behave_like "an action with an invalid user"
    end

    describe "for a user without an avatar" do
      let(:user) { user_without_avatar }
      it_should_behave_like "an action with stubbed User.find"
      let(:do_action) { get :dump_avatar, :id => 123}
      it_should_behave_like "an action with an invalid user"
    end

    describe "for a user with an avatar" do
      let(:user) { user_with_avatar }
      it_should_behave_like "an action with stubbed User.find"
      before do
        @controller.stub!(:send_file).and_return true
      end
      let(:do_action) { get :dump_avatar, :id => 345}
      it { do_action; response.should be_success }
      it { @controller.should_receive(:send_file).and_return true; do_action }
    end
  end
  
  describe "GET /users/:id/update_avatar" do
    before{ User.stub!(:current).and_return Factory.create(:admin) }
    describe "WHEN save submit" do
      let(:submit_param) { {:commit => :button_save} }
      describe "for an invalid user" do
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 0)}
        it_should_behave_like "an action with an invalid user"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should be_blank }
      end

      describe "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 123)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(123) }
        specify { Attachment.should_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "changed" }
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 345)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(345) }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "changed" }
      end
    end

    describe "WHEN delete submit" do
      let(:submit_param) { {:delete => :true} }
      describe "for an invalid user" do
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 0)}
        it_should_behave_like "an action with an invalid user"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should be_blank }
      end

      describe "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 123)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(123) }
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "deleted" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 345)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(345) }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "deleted" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end
    end
  end
end