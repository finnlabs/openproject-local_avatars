require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it_should_behave_like "there are users with and without avatars"
  let(:user) { Factory.build :user }
  
  specify { user.attachments.should be_a_kind_of Array }
  
  describe "#local_avatar_attachment" do
    subject { user.local_avatar_attachment }

    describe "WHEN user has an avatar" do
      let(:user) {user_with_avatar}
      it { should be_a_kind_of Attachment }
    end

    describe "WHEN user has no avatar" do
      let(:user) {user_without_avatar}
      it { should be_blank }
    end
  end
  
  describe "#local_avatar_attachment=" do
    describe "WHEN the uploaded file is not an image" do
      subject { lambda{ user.local_avatar_attachment = bogus_avatar_file } }
      let(:rescue_block) { lambda{ begin; subject; rescue; false end } }
      it { should raise_error }
      specify { rescue_block.should_not change(user, :local_avatar_attachment) }
    end

    describe "WHEN the uploaded file is a good image" do
      subject { lambda{ user.local_avatar_attachment = avatar_file } }
      it { should_not raise_error }
      specify { should change(user, :local_avatar_attachment) }
    end
  end
end