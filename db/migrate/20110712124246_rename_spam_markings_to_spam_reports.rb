class RenameSpamMarkingsToSpamReports < ActiveRecord::Migration
  def self.up
    rename_table :spam_markings, :spam_reports
  end

  def self.down
    rename_table :spam_reports, :spam_markings
  end
end
