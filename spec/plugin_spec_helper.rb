module ChiliprojectLocalAvatars::PluginSpecHelper
  shared_examples_for "an action checked for required login" do
    before do
      Setting.stub!(:login_required?).and_return(false)
    end

    describe "WITH no login required" do
      before do
        action
      end

      it "should be success" do
        response.should be_success
      end
    end

    describe "WITH login required" do
      before do
        Setting.stub!(:login_required?).and_return(true)

        action
      end

      it "should redirect to the login page" do
        response.should redirect_to signin_path(:back_url => redirect_path)
      end
    end
  end

  shared_examples_for "an action requiring login" do
    let(:current) { Factory.create(:user) }

    before do
      User.stub(:current).and_return(current)
    end

    describe "without beeing logged in" do
      before do
        User.stub(:current).and_return AnonymousUser.first

        action
      end

      it { response.should redirect_to signin_path(:back_url => redirect_path) }
    end

    describe "with beeing logged in" do
      before do
        action
      end

      it { response.should be_success }
    end
  end


  shared_examples_for "an action requiring admin" do
    let(:current) { Factory.create(:admin) }

    before do
      User.stub(:current).and_return(current)
    end

    describe "without beeing logged in" do
      before do
        User.stub(:current).and_return AnonymousUser.first

        action
      end

      it { response.should redirect_to signin_path(:back_url => redirect_path) }
    end

    describe "with beeing logged in as a normal user" do
      before do
        User.stub(:current).and_return Factory.create(:user)

        action
      end

      it { response.response_code.should == 403 }
    end

    describe "with beeing logged in as admin" do
      before do
        action
      end

      it do
        if respond_to? :successful_response
          successful_response
        else
          response.should be_success
        end
      end
    end
  end

  shared_examples_for "there are users with and without avatars" do
    let(:user_without_avatar) {Factory.create :user}
    let(:uwoa_id) {user_without_avatar.id}
    let(:user_with_avatar) do
      u = Factory.create :user
      u.attachments = [Factory.build(:avatar, :author => u)]
      u
    end
    let(:uwa_id) { user_with_avatar.id }
    let(:avatar_file) do
      image = Magick::Image.new(200,200)
      image.format = "PNG"
      file = Tempfile.new('avatar_image_spec')
      file.stub!(:original_filename).and_return('foo.jpg')
      file.stub!(:content_type).and_return('image/jpeg')
      file.write image.to_blob
      file.rewind
      file
    end
    let(:bogus_avatar_file) do
      file = Tempfile.new('avatar_bogus_spec')
      file.stub!(:original_filename).and_return('foo.jpg')
      file.stub!(:content_type).and_return('image/jpeg')
      file.write "alert('Bogus')"
      file.rewind
      file
    end
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
      User.stub!(:find).and_return { |id, args| (id.to_s == "0") ? nil : user }
    end
  end

  shared_examples_for "an action that deletes the user's avatar" do
    it { File.should_receive(:delete).and_return true; do_action }
  end
end
