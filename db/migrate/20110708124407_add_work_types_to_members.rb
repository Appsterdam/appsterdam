class AddWorkTypesToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :work_types, :text
  end

  def self.down
    remove_column :members, :work_types
  end
end
