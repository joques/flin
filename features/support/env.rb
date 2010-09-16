begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
gem 'cucumber'
require 'cucumber'
gem 'rspec'
#require 'rspec'

$:.unshift(File.dirname(__FILE__) + '/../../lib/flin/bookmark')
require 'bookmark'


Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path
  path = %w{.. .. .. data urlsink.yml}
  @bookmark = Flin::Bookmark.new(path)
end


