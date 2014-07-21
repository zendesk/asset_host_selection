require 'bundler/setup'
require 'bundler/gem_tasks'
require 'bump/tasks'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test
