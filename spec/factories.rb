Factory.define :user do |user|
  user.provider "factory provider"
  user.uid      "factory uid"
  user.name     "Factory User"
  user.email    "factory@example.com"
end