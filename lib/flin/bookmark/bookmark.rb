require 'yaml'
require 'uri'
require 'rufus/tokyo/tyrant'

module Flin
  class Bookmark
    attr_reader :entries
    attr_reader :entry_path
    
    # a yml file is expected as the local data path. Here we assume 
    def initialize(local_data_path)
      if local_data_path.nil?
        @entry_path = %w{.. .. .. data urls.yml}
      else
        raise(RuntimeError, "Sorry! url file does not exist") unless check_file?(local_data_path)
        @entry_path = local_data_path
      end
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
          current_url_val.gsub!(old_url, new_url)
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
        current_url_vals = @entries[valid_title]
        if current_url_vals.include?(url)
          current_url_vals.gsub!(url, '')
          
          # clean-up any comma mixed-up with space that might remain
          current_url_vals.gsub!(/\A,|\s+,|\s*,\s*\z|\s*\z/,'')
          
          # finally, reassign the updated value
          if current_url_vals.empty?
            @entries.delete(valid_title)
          else
            @entries[valid_title] = current_url_vals
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
      # The current version of the sync does not account for updates and
      # deletes. Need to keep track of the operation in order to do so
      
      sync_with_central_db(db_host, db_port, @entry_path)
      "Local bookmarks successfully synced with database!"
    end
    
    # automatic string conversion method for the class
    def to_s
      # should beautify the entry display

      pretty_bmk = @entries.inject('') do |final_str, (entry_key, entry_vals)|
        final_str << entry_key << ":" << "\t" << entry_vals << "\n"
        final_str
      end
      pretty_bmk
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
    
    def get_file(path)
      file = File.join(File.dirname(__FILE__), path)
    end
    
    def check_file?(path)
      file_name = get_file(path)
      File.exists?(file_name)
    end
    
    def load_entries(path)
      bmk_file = get_file(path)
      yaml_str = IO.read(bmk_file)
      YAML.load(yaml_str)  
    end
    
    def save_entries(path)
      yaml_entries = @entries.to_yaml
      valid_file_name = get_file(path)
      
      File.open(valid_file_name, "w") do |f|
        f.write(yaml_entries)
      end
    end
    
    def sync_with_central_db(db_host, db_port, path)       
       # We use this hash to merge to the local and central data stores
       synced_entries = Hash.new
        
       begin
         #Maybe I should try and catch some exception here
         central_urls = Rufus::Tokyo::Tyrant.new(db_host, Integer(db_port))         
       rescue Rufus::TokyoError
         # handle error
         puts "Cannot access the tyrant server at host #{db_host} and port #{db_port}"
         raise(RuntimeError, "Tokyo Tyrant server not available")
       else
         # First, we copy the content of the db
         central_urls.each do |central_key, central_vals|
           synced_entries[central_key] = central_vals
         end         
         
         # Next, we merge with entries from the local file. Also, we remove all
         # the duplicates
         @entries.each do |local_key, local_vals|
           synced_vals = synced_entries[local_key]
           if synced_vals.nil?
             synced_entries[local_key] = local_vals
           else
             local_val_array = local_vals.split(/,\s*/)
             for loc_val in local_val_array
               unless synced_vals.include?(loc_val)
                 synced_vals << ', ' 
                 synced_vals << loc_val
               end
             end
             synced_entries[local_key] = synced_vals
           end
         end
         # Finally, copy the new hash back to the db
         synced_entries.each do |new_key, new_val|
           central_urls[new_key] = new_val
         end                   
       ensure
         # close the data store
          central_urls.close unless central_urls.nil?
       end

      #update the entries and save the file locally
      @entries = synced_entries
      save_entries(path)      
    end
        
  end
end