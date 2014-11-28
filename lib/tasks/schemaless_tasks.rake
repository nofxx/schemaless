#
# Schemaless Tasks
#
namespace :schemaless do


  desc "Updates the database!"
  task :up => :environment do
    Schemaless.sandbox = true if ARGV.join =~ /sandbox|print|safe/
    Schemaless.work
  end

end
