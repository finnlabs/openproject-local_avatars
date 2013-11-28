FactoryGirl.define do
  factory :avatar, class: Attachment do
    description  "avatar"
    filename     "avatar.jpg"
    content_type "image/jpeg"
    association :author, :factory => :user
  end
end