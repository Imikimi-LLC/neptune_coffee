require "bundler/gem_tasks"
require "pathname"

require 'rspec'
require 'rspec/core/rake_task'

desc "Run all examples with RCov"
RSpec::Core::RakeTask.new('spec:rcov') do |t|
  t.rcov = true
end

RSpec::Core::RakeTask.new('spec') do |t|
  t.verbose = true
end

desc "Regenerate examples/after based on examepls/before"
task :reset_examples do
  root = Pathname.new(__FILE__).parent.relative_path_from Pathname.pwd
  binary = root + "bin/neptune_coffee"
  examples = root + "examples"
  examples_before = examples + "before"
  examples_after = examples + "after"
  puts "rm -r #{examples_after}"
  examples_after.rmtree
  command = "cp -v -R #{examples_before} #{examples_after}"
  puts command
  system command
  # `#{command}`
  command = "#{binary} -o -r #{examples_after}"
  `#{command}`
end

task :default => :spec
