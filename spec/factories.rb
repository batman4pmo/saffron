Factory.define :user do |user|
  user.name                  "Test User"
  user.email                 "test.user@example.com"
  user.password              "password"
  user.password_confirmation "password"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :project do |project|
  project.name        "Test Project"
  project.client      "Test Project Client"
  project.description "Test Project Description"
  project.association :user
end