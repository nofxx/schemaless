#
# Schemaless Guardfile
#
# ignore(/\/.#.+/)

# notification :off

guard :rubocop, all_on_start: false, keep_failed: false,
      notification: false, cli: ['-D'] do
  watch(/^lib\/(.+)\.rb$/)
end

guard :rspec, cmd: 'bundle exec rspec', notification: true do
  watch(/^spec\/dummy\/(.+)\.rb$/)
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^lib\/(.+)\.rb$/)     { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^generators\/(.+)\.rb$/) { |m| 'spec/schemaless/worker_spec' }

  watch('spec/spec_helper.rb')  { 'spec' }
end
