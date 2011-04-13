class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :client
      t.string :description
      t.string :image
      t.string :wiki
      t.string :issue_tracker
      t.integer :resource_id
      t.integer :environment_id
      t.integer :technology_id

      t.timestamps
    end
    add_index :projects, :name
  end

  def self.down
    drop_table :projects
  end
end
