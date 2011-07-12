class RenamePlatformsAndWorkTypes < ActiveRecord::Migration
  def self.up
    rename_column :members, :platforms, :platforms_as_string
    rename_column :members, :work_types, :work_types_as_string
  end

  def self.down
    rename_column :members, :platforms_as_string, :platforms
    rename_column :members, :work_types_as_string, :work_types
  end
end
