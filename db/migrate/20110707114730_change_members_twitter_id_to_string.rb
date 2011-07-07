class ChangeMembersTwitterIdToString < ActiveRecord::Migration
  def self.up
    change_column :members, :twitter_id, :string
  end

  def self.down
    change_column :members, :twitter_id, :integer
  end
end
