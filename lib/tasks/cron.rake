desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  log = Logger.new(STDOUT)
  Event.sync_events false, log
end
