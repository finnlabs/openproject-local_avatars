module ChiliprojectLocalAvatars::PluginSpecHelper
  shared_examples_for "there are users with and without avatars" do
    let(:user_without_avatar) { u = Factory.create :user; u.stub!(:id).and_return 123; u }
    let(:user_with_avatar) { u = Factory.create :user_with_avatar; u.stub!(:id).and_return 345;u }
  end

  shared_examples_for "a controller with avatar features" do
    it_should_behave_like "there are users with and without avatars"
    before do
      User.stub!(:current).and_return Factory.create(:anonymous)
      File.stub!(:delete).and_return true
    end
  end
  
  shared_examples_for "an action with an invalid user" do
    it { do_action; response.should_not be_success }
    it { do_action; response.code.should == "404"}
  end

  shared_examples_for "an action with stubbed User.find" do
    before do
      user.stub!(:save).and_return true if user
      User.stub!(:find).and_return { |id| (id.to_s == "0") ? nil : user }
    end
  end
  
  shared_examples_for "an action that deletes the user's avatar" do
    it { File.should_receive(:delete).and_return true; do_action }
  end
end