class AddAsNewToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :as_new, :boolean, :default => true
  end

  def self.down
    remove_column :members, :as_new
  end
end
