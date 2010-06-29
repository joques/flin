require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib flin bookmark bookmark]))

begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  #require 'spec'
end

# $:.unshift(File.dirname(__FILE__) + '/../lib/flin')
# require 'flin'
