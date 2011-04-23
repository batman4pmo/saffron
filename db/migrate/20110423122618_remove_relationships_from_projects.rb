class RemoveRelationshipsFromProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :resource_id
    remove_column :projects, :environment_id
    remove_column :projects, :technology_id
  end

  def self.down
    add_column :projects, :resource_id, :integer
    add_column :projects, :environment_id, :integer
    add_column :projects, :technology_id, :integer
  end
end
