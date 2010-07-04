require 'yaml'

module Flin
  class Bookmark
    attr_reader :entries
    
    def initialize
      path = %w[.. .. .. data urlsink.yml]
      bmk_file = File.join(File.dirname(__FILE__), path)
      yaml = IO.read(bmk_file)
      @entries = YAML.load(yaml)
    end
    
    # this method checks if there exists an entry with a given title in the bookmarks      
    def exists_entry_with_title?(title)
      raise ArgumentError unless title.kind_of? String
      valid_title = clean_title(title)
      entries.has_key?(valid_title)
    end
    
    #this method checks if a given url has been paired with a title in the bookmarks
    def is_url_paired_with_title?(title, url)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless url.kind_of? String
      
      raise(RuntimeError, "Sorry! the old URL is malformed") unless validate_url?(url)
      
      if exists_entry_with_title?(title)
        entry_val = entries[clean_title(title)]
        entry_val.include?(url)  
      else
        false
      end
    end    
    
    # this method adds a new entry to the bookmarks. Adding a new entry can happen in tow possible.
    # A fresh entry can be added to the bookmarks. A url can also be appended to an existing entry
    def add(title, url, option = :extend)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless url.kind_of? String
      raise ArgumentError unless option.kind_of? Symbol
      
      # should strip off all white space and special characters from title
      valid_title = clean_title(title)
      
      # should check that url is valid
      raise(RuntimeError, "Sorry! the URL is malformed.") unless validate_url?(url)
      
      valid_url = url
      
      # perform the final action      
      added = case option
      when :extend
        # should concatenate the string in this case
        old_url = entries[valid_title]
        
        if old_url == nil
          old_url = ''
        else
          old_url << ', '
        end
        
        new_url = old_url
        
        new_url << valid_url
        
        entries[valid_title] = new_url
        "Bookmark entry successfully extended!"
      when :new
        if entries.has_key?(valid_title)
          "Sorry! A bookmark entry with this title already exists!"
        else
          entries[valid_title] = valid_url
          "New bookmark entry successfully added!"
        end
      end      
    end
    
    def update(title, old_url, new_url)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless old_url.kind_of? String
      raise ArgumentError unless new_url.kind_of? String
      
      #strip off all white spaces and special characters from title
      valid_title = clean_title(title)
      
      #should validate both old and new urls
      raise(RuntimeError, "Sorry! the old URL is malformed") unless validate_url?(old_url)
      raise(RuntimeError, "Sorry! the new URL is malformed") unless validate_url?(new_url)
      
      if entries.has_key?(valid_title)
        current_url_val = entries[valid_title]
        if current_url_val.include?(old_url)  
          current_url_val.gsub(old_url, new_url)
          entries[valid_title] = current_url_val
          "Bookmark entry successfully updated!"
        else
          "Sorry! The old url has never been attached to the title"
        end                  
      else
        "Sorry! There is no bookmark entry with this title"
      end    
    end
    
    def delete(title, url)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless url.kind_of? String
      
      valid_title = clean_title(title)
      
      raise(RuntimeError, "Sorry! the url is malformed")  unless validate_url?(url)
      
      if entries.has_key?(valid_title)
        current_url_val = entries[valid_title]
        if current_url_val.include?(url)
          current_url_val.gsub(url,'')
          if current_url_val.empty?
            entries[valid_title] = nil
          else
            entries[valid_title] = current_url_val
          end
          "Bookmark entry successfully deleted!"
        else
          "Sorry! The url has never been attached to the title"
        end
      else
        "Sorry! There is no bookmark entry with this title"
      end
    end
    
    def get(title)
      raise ArgumentError unless title.kind_of? String
      
      valid_title = clean_title(title)
      
      if entries.has_key?(valid_title)
        entries[valid_title]
      else
        "Sorry! There is no bookmark entry with this title"
      end
    end
    
  private
    
    #this method strips off white space and special characters from the title
    def clean_title(title)
      valid_title = title
      # valid_title = title.chop!
      # valid_title = valid_title.chomp!
      valid_title = valid_title.downcase
      valid_title
    end
    
    #this method uses a regular expression to validate a url. Here we accept
    #http, https, ftp, file and git
    def validate_url?(url)
      url_regex = Regexp.new('(https|http|file|ftp|git)://[a-z0-9]+([-.]{1}[a-z0-9]+)*.[a-z]{2,5}(([0-9]{1,5})?/.*)?')
      url =~ url_regex
    end
        
  end
end