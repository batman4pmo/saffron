# == Schema Information
# Schema version: 20110423122618
#
# Table name: projects
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  client        :string(255)
#  description   :string(255)
#  image         :string(255)
#  wiki          :string(255)
#  issue_tracker :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#

class Project < ActiveRecord::Base
  attr_accessible :name, :client, :description, :image, :wiki, :issue_tracker

  belongs_to :user

  validates :user_id,     :presence => true

  validates :name,        :presence => true,
                          :length   => { :maximum => 80 }

  validates :client,      :presence => true,
                          :length   => { :maximum => 80 }

  validates :description, :length   => { :maximum => 150 }

  #TODO: Validation for Urls

  default_scope :order => 'projects.name ASC'
end
