Factory.add_to :user do |u|
  u.after_create do |user|
    user.password = nil
  end
end
