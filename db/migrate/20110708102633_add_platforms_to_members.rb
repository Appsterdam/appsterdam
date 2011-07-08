class AddPlatformsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :platforms, :text
  end

  def self.down
    remove_column :members, :platforms
  end
end
