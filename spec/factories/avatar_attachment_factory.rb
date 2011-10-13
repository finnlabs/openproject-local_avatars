Factory.define :avatar, :class => Attachment do |a|
  a.description  "avatar"
  a.filename     "avatar.jpg"
  a.content_type "image/jpeg"
  a.association :author, :factory => :user
end