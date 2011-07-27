begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

dir = File.dirname(__FILE__)

$:.unshift(File.join(dir, '/../lib/'))
require dir + '/../lib/realex'

def stdout_for(&block)
  # Inspired by http://www.ruby-forum.com/topic/58647
  old_stdout = $stdout
  $stdout = StringIO.new
  yield
  output = $stdout.string
  $stdout = old_stdout
  output
end