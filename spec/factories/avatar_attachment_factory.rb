FactoryGirl.define do
  factory :avatar_attachment, class: Attachment do
    description  "avatar"
    filename     "avatar.jpg"
    content_type "image/jpeg"
    association :author, :factory => :user

    after(:build) do |avatar|
      path = OpenProject::Configuration['attachments_storage_path'] ||
          Rails.root.join('files').to_s
      File.open(path + '/' + avatar.disk_filename, "w")
    end
  end

end
