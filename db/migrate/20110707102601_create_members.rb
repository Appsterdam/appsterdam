class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :twitter_id
      t.string :name
      t.string :username
      t.string :picture
      t.string :location
      t.string :website
      t.string :bio

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
