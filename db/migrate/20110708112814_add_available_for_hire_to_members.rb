class AddAvailableForHireToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :available_for_hire, :boolean
  end

  def self.down
    remove_column :members, :available_for_hire
  end
end
