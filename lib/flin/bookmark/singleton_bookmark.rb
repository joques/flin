require 'singleton'

module Flin
  class SingletonBookmark < Bookmark
    include Singleton
  end
end