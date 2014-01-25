require "bundler/gem_tasks"

require 'rspec'
require 'rspec/core/rake_task'

desc "Run all examples with RCov"
RSpec::Core::RakeTask.new('spec:rcov') do |t|
  t.rcov = true
end

RSpec::Core::RakeTask.new('spec') do |t|
  t.verbose = true
end

task :default => :spec
