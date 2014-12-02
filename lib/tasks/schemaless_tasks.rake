#
# Schemaless Tasks
#
#
# Guess this might be deleted and use only generators, or versa-vice.
#
namespace :schemaless do

  desc "Runs in wild mode!"
  task :run => :environment do
    Schemaless.sandbox = true if ARGV.join =~ /sandbox|print|safe/
    Rails.application.eager_load!
    Schemaless::Worker.run!
  end

  # Use rails generate schemaless:migrations
  # desc "Creates migrations!"
  # task :migration => :environment do
  #   Schemaless.sandbox = true if ARGV.join =~ /sandbox|print|safe/
  #   Schemaless::Worker.generate!
  # end

end
