require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it_should_behave_like "there are users with and without avatars"
  let(:user) { Factory.build :user }
  
  specify { user.attachments.should be_a_kind_of Array }
  
  describe "#local_avatar_attachment" do
    subject {user.local_avatar_attachment}

    describe "WHEN user has an avatar" do
      let(:user) {user_with_avatar}
      it { should be_a_kind_of Attachment }
    end

    describe "WHEN user has no avatar" do
      let(:user) {user_without_avatar}
      it { should be_blank }
    end
  end
end