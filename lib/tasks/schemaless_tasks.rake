#
# Schemaless Tasks
#
namespace :db do

  desc "Updates the database!"
  task :up do
    Schemaless.work
  end

end
