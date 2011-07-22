# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Appsterdam::Application.load_tasks

namespace :test do
  Rake::TestTask.new('lib') do |t|
    t.test_files = FileList['test/lib/**/*_test.rb']
    t.verbose = true
  end
end

task :test do
  Rake::Task['test:lib'].invoke
end

desc "Deletes the classified ads that are over 30 days old"
task :purge_outdated_classifieds => :environment do
  Classified.purge_outdated!
end

desc 'Have cron index the Sphinx search indices'
task :cron => ['fs:index', 'purge_outdated_classifieds']