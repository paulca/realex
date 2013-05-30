require 'rake'
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--colour --format progress']
  spec.pattern = 'spec/**/*_spec.rb'
end

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'lib/**/*',
  'rails/**/*'
]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "realex"
    gemspec.summary = "Ruby interface to http://realexpayments.com"
    gemspec.description = "A Ruby library to make use of the payments API at http://realexpayments.com"
    gemspec.email = "paul@rslw.com"
    gemspec.homepage = "http://github.com/paulca/realex"
    gemspec.authors = ["Paul Campbell"]
    gemspec.version = "0.4.1"
    gemspec.add_dependency 'nokogiri', '~> 1.4'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Jeweler::GemcutterTasks.new
