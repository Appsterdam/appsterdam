class AddMarkedAsSpamToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :marked_as_spam, :boolean, :default => false
  end

  def self.down
    remove_column :members, :marked_as_spam
  end
end
