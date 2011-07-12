class CreateSpamMarkings < ActiveRecord::Migration
  def self.up
    create_table :spam_markings do |t|
      t.integer :member_id
      t.integer :reporter_id
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :spam_markings
  end
end
