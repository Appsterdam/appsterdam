class AddRoleToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :role, :string, :default => 'member'
  end

  def self.down
    remove_column :members, :role
  end
end
