# == Schema Information
# Schema version: 20110403041052
#
# Table name: users
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :provider, :presence   => true
  validates :uid,      :presence   => true
  validates :name,     :presence   => true,
                       :length     => { :maximum => 50 }
  validates :email,    :presence   => true,
                       :format     => { :with => email_regex },
                       :uniqueness => { :case_sensitive => false }

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["nickname"]
      user.email = auth["user_info"]["email"]
    end
  end

end
