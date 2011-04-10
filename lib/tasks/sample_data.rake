require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
  end
end

def make_users
  admin = User.create!(:name => "Example User",
                       :email => "user@example.com",
                       :password => "password",
                       :password_confirmation => "password")
  admin.toggle!(:admin)
  
  99.times do |n|
    name = Faker::Name.name
    email = "user-#{n+1}@example.com"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end  
end