require 'rake'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
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
    gemspec.version = "0.2.3"
    gemspec.add_dependency 'hpricot', '0.6.164'
    gemspec.add_dependency 'rio'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Jeweler::GemcutterTasks.new
