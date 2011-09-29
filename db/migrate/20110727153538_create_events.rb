class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string    :name
      t.text      :description
      t.datetime  :starts_at
      t.datetime  :ends_at
      t.string    :url
      t.float     :fee
      t.string    :fee_description
      t.string    :location
      t.float     :lon
      t.float     :lat

      t.datetime :created_at
    end
  end

  def self.down
    drop_table :events
  end
end
