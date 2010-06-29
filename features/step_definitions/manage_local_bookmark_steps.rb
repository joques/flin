 Given /^the entry title (.*) does not exist$/ do |title|
   @bookmarks = Bookmarks.new
      @bookmarks.exists_entry_with_title(title).should be_false
    end

When /^I add-new with entry title (.*) and entry url (.*)$/ do |title, url|
  puts "tried to add new title and url"
end

Then /^I should see a message (.*)$/ do |message|
  message
end