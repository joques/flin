require 'yaml'

module Flin
  class Bookmarks
    attr_reader :entries
    
    def initialize
      path = %w[.. .. .. data urlsink.yml]
      bmk_file = File.join(File.dirname(__FILE__), path)
      yaml = IO.read(bmk_file)
      @entries = YAML.load(yaml)
    end
    
    def exists_entry_with_title(title)
      false
    end
    
  end
end