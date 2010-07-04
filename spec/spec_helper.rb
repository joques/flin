require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib flin]))
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib flin bookmark bookmark]))

begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'rspec'
end

# $:.unshift(File.dirname(__FILE__) + '/../lib')
# require 'flin'
