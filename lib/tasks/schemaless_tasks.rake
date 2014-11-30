#
# Schemaless Tasks
#
#
# Guess this might be deleted and use only generators, or versa-vice.
#
namespace :schemaless do

  desc "Runs in live mode!"
  task :run => :environment do
    Schemaless.sandbox = true if ARGV.join =~ /sandbox|print|safe/
    Schemaless::Worker.run!
  end

  desc "Creates migrations!"
  task :migration => :environment do
    Schemaless.sandbox = true if ARGV.join =~ /sandbox|print|safe/
    Schemaless::Worker.generate!
  end

end
