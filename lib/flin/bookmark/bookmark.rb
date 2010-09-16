require 'yaml'
require 'uri'
require 'rufus/tokyo/tyrant'

module Flin
  class Bookmark
    attr_reader :entries
    attr_reader :entry_path
    
    # a yml file is expected as the local data path. Here we assume 
    def initialize(local_data_path)
      @entry_path = local_data_path
      @entries = load_entries(@entry_path)
    end
    
    # this method checks if there exists an entry with a given title in the
    # bookmarks      
    def exists_entry_with_title?(title)
      raise ArgumentError unless title.kind_of? String
      valid_title = clean_title(title)
      @entries.has_key?(valid_title)
    end
    
    #this method checks if a given url has been paired with a title in the
    #bookmarks
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
    
    # this method adds a new entry to the bookmarks. Adding a new entry can
    # happen in two possible. A fresh entry can be added to the bookmarks. A
    # url can also be appended to an existing entry
    def add(title, url, option = :extend)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless url.kind_of? String
      raise ArgumentError unless option.kind_of? Symbol
      
      # should strip off all white space and special characters from title
      valid_title = clean_title(title)
      valid_title.freeze
      
      # should check that url is valid
      raise(RuntimeError, "Sorry! the URL is malformed.") unless validate_url?(url)
      
      valid_url = url
      
      # perform the final action      
      added = case option
      when :extend
        # should concatenate the string in this case
        old_url = @entries[valid_title]
                
        if old_url.nil?
          @entries[valid_title] = valid_url
        else
          unless old_url.include?(valid_url)
            old_url << ', '
            old_url << valid_url
            @entries[valid_title] = old_url
          end
        end
        
        "Bookmark entry successfully extended!"
      when :new
        if @entries.has_key?(valid_title)
          "Sorry! A bookmark entry with this title already exists!"
        else
          @entries[valid_title] = valid_url
          "New bookmark entry successfully added!"
        end
      end      
    end
    
    # this method looks for an entry corresponding to the title and replaces
    # the old url with the new one
    def update(title, old_url, new_url)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless old_url.kind_of? String
      raise ArgumentError unless new_url.kind_of? String
      
      #strip off all white spaces and special characters from title
      valid_title = clean_title(title)
      
      #should validate both old and new urls
      raise(RuntimeError, "Sorry! the old URL is malformed") unless validate_url?(old_url)
      raise(RuntimeError, "Sorry! the new URL is malformed") unless validate_url?(new_url)
      
      if @entries.has_key?(valid_title)
        current_url_val = @entries[valid_title]
        if current_url_val.include?(old_url)  
          current_url_val.gsub(old_url, new_url)
          @entries[valid_title] = current_url_val
          "Bookmark entry successfully updated!"
        else
          "Sorry! The old url has never been attached to the title"
        end                  
      else
        "Sorry! There is no bookmark entry with this title"
      end    
    end
    
    # this method looks for an entry corresponding to the title and removes
    # the url it exists
    def delete(title, url)
      raise ArgumentError unless title.kind_of? String
      raise ArgumentError unless url.kind_of? String
      
      valid_title = clean_title(title)
      
      raise(RuntimeError, "Sorry! the url is malformed")  unless validate_url?(url)
      
      if @entries.has_key?(valid_title)
        current_url_val = @entries[valid_title]
        if current_url_val.include?(url)
          # should be areful about the comma added after each url
          url_followed_by_comma = url
          url_followed_by_comma << ', '
          
          if current_url_val.include?(url_followed_by_comma)
            current_url_val.gsub(url_followed_by_comma,'')
          else
            current_url_val.gsub(url,'')
          end          
          
          if current_url_val.empty?
            @entries.delete(valid_title)
          else
            @entries[valid_title] = current_url_val
          end
          "Bookmark entry successfully deleted!"
        else
          "Sorry! The url has never been attached to the title"
        end
      else
        "Sorry! There is no bookmark entry with this title"
      end
    end
    
    # this method returns all the urls associated with the title
    def get(title)
      raise ArgumentError unless title.kind_of? String
      
      valid_title = clean_title(title)
      
      if @entries.has_key?(valid_title)
        @entries[valid_title]
      else
        "Sorry! There is no bookmark entry with this title"
      end
    end
    
    
    # this method saves the bookmark entries to a local file
    def save
      save_entries(@entry_path)
      "Bookmark entries successfully stored locally!"
    end
    
    
    # this method synchronizes the local bookmark entries with the central
    # database
    def sync_db(db_host, db_port)
      sync_with_central_db(db_host, db_port, @entry_path)
      "Local bookmarks successfully synced with database!"
    end
    
    # automatic string conversion method for the class
    def to_s
      @entries
    end
        
  private
    
    #this method strips off white space and special characters from the title
    def clean_title(title)
      title.chomp
      title.downcase
    end
    
    #this method uses a regular expression to validate a url. Here we accept
    #http, https, ftp, file and git
    def validate_url?(url)
      url_regex = Regexp.new('(^$)|(^(http|https|file|ftp|git):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)')
      url =~ url_regex              
    end
    
    def load_entries(path)
      bmk_file = File.join(File.dirname(__FILE__), path)
      yaml_str = IO.read(bmk_file)
      YAML.load(yaml_str)  
    end
    
    def save_entries(file_name)
      yaml_entries = @entries.to_yaml
      valid_file_name = File.join(File.dirname(__FILE__), file_name)
      
      File.open(valid_file_name, "w") do |f|
        f.write(yaml_entries)
      end
    end
    
    def sync_with_central_db(db_host, db_port, file_name)
      #Maybe I should try and catch some exception here    
      central_urls = Rufus :: Tokyo :: Tyrant.new(db_host, db_port)
      synced_entries = {}
            
      #do the synchronization as follows
      
      # fisrt create a copy of the retrieved hash
      synced_entries = central_urls.clone
            
      # then extend the new hash with entries from the local file. Also, we
      # remove all the duplicates
      @entries.each do |local_key, local_vals|
        if synced_entries.has_key?(local_key)
          old_val = synced_entries[local_key]
          if old_val.nil?
            synced_entries[local_key] = local_vals
          else
            local_vals_array = local_vals.split(/,\s*/)
            local_vals_wo_dup = ''
            for loc_val in local_vals_array
              unless old_val.include?(loc_val)
                local_vals_wo_dup << ', '
                local_vals_wo_dup << loc_val
              end
            end
            old_val << local_vals_wo_dup
            synced_entries[local_key] = local_vals_wo_dup
          end          
      end
      
      # Finally, copy thenew hash back to the db
      synced_entries.each do |new_key, new_val|
        central_urls[new_key] = new_val
      end
            
      central_urls.close
      
      @entries = synced_entries
      save_entries(file_name)      
    end
        
  end
end