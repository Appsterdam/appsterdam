class AddEntityAndWorkLocationToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :entity, :string
    add_column :members, :work_location, :string
  end

  def self.down
    remove_column :members, :work_location
    remove_column :members, :entity
  end
end
