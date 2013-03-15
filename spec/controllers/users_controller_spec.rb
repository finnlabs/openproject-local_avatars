require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  it_should_behave_like "a controller with avatar features"

  describe "GET /users/:id/dump_avatar" do
    let(:user) { user_with_avatar }
    let(:action) { get :dump_avatar, :id => user.id.to_s }
    let(:redirect_path) { dump_user_avatar_url(:id => user.id) }
    before do
      @controller.stub!(:send_file).and_return true
    end
    it_should_behave_like "an action checked for required login"

    describe "for an invalid user" do
      let(:do_action) { get :dump_avatar, :id => 0}
      it_should_behave_like "an action with an invalid user"
    end

    describe "for a user without an avatar" do
      let(:user) { user_without_avatar }
      it_should_behave_like "an action with stubbed User.find"
      let(:do_action) { get :dump_avatar, :id => uwoa_id}
      it_should_behave_like "an action with an invalid user"
    end

    describe "for a user with an avatar" do
      let(:user) { user_with_avatar }
      it_should_behave_like "an action with stubbed User.find"
      let(:do_action) { get :dump_avatar, :id => uwa_id}
      it { do_action; response.should be_success }
      it { @controller.should_receive(:send_file).and_return true; do_action }
    end
  end

  describe "GET /users/:id/update_avatar" do
    let(:user) { user_with_avatar }
    let(:action) { post :update_avatar, :avatar => avatar_file, :id => user.id }
    let(:redirect_path) { update_user_avatar_url(:id => user.id) }
    let(:successful_response) do
      response.should redirect_to({ :controller => 'users',
                                    :action => 'edit',
                                    :id => user.id } )
    end
    it_should_behave_like "an action requiring admin"

    describe "WHEN save submit" do
      let(:submit_param) { {:commit => :button_save, :avatar => avatar_file} }
      describe "for an invalid user" do
        let(:do_action) { post :update_avatar, submit_param.merge(:id => 0)}
        it_should_behave_like "an action with an invalid user"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should be_blank }
      end

      describe "for a user without an avatar" do
        let(:user) { user_without_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => uwoa_id)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(uwoa_id) }
        specify { Attachment.should_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "changed" }
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => uwa_id)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(uwa_id) }
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
        let(:do_action) { post :update_avatar, submit_param.merge(:id => uwoa_id)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(uwoa_id) }
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:error].should include_text "could not be deleted" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end

      describe "for a user with an avatar" do
        let(:user) { user_with_avatar }
        it_should_behave_like "an action with stubbed User.find"
        let(:do_action) { post :update_avatar, submit_param.merge(:id => uwa_id)}
        it { do_action; response.should be_redirect }
        it { do_action; should redirect_to edit_user_path(uwa_id) }
        it_should_behave_like "an action that deletes the user's avatar"
        specify { Attachment.should_not_receive(:attach_files); do_action }
        it { do_action; flash[:notice].should include_text "deleted successfully" }
        it { do_action; user.local_avatar_attachment.should be_blank}
      end
    end
  end
end
