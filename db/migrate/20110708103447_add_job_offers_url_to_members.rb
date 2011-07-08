class AddJobOffersUrlToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :job_offers_url, :text
  end

  def self.down
    remove_column :members, :job_offers_url
  end
end
