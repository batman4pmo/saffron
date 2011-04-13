# == Schema Information
# Schema version: 20110410222608
#
# Table name: projects
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  client         :string(255)
#  description    :string(255)
#  image          :string(255)
#  wiki           :string(255)
#  issue_tracker  :string(255)
#  resource_id    :integer
#  environment_id :integer
#  technology_id  :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Project < ActiveRecord::Base
  attr_accessible :name, :client, :description, :image, :wiki, :issue_tracker
end
