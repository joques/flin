require 'singleton'

module Flin
  class SingletonBookmark < Bookmark
    include Singleton
    
    def initialize(local_data_path = nil)
      super(local_data_path)
    end
  end
end