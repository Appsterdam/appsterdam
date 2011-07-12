class CreateClassifieds < ActiveRecord::Migration
  def self.up
    create_table :classifieds do |t|
      t.boolean :offered
      t.string :category
      t.text :title
      t.text :description
      t.integer :placer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :classifieds
  end
end
