Given /^the bookmark entries$/ do
  @bookmark.should_not be_nil
end

Given /^the entry title (.*) does not exist$/ do |title|
  Given "the bookmark entries"
  @bookmark.exists_entry_with_title(title).should be_false
end

Given /^the entry title (.*) exists$/ do |title|
  Given "the bookmark entries"
  @bookmark.exists_entry_with_title(title).should be_true
end

Given /^the title (.*) is associated with the url (.*)$/ do |title, url| 
  entry = @bookmark.entries
  entry_val = entry[title]
  entry_val.should_not be_nil
  entry_val.include?(url).should be_true
end

When /^I update entry title (.*) with new url (.*) where url is (.*)$/ do |title, old_url, new_url|
  @response = @bookmark.update(title, old_url, new_url)
end

When /^I add new entry with title (.*), entry url (.*) and option new$/ do |title, url|
  @response = @bookmark.add(title, url, :new)
end

When /^I add new entry with title (.*) and url (.*)$/ do |title, url| 
  @response = @bookmark.add(title, url)
end

Then /^I should see a message (.*)$/ do |message|
  @response.should eql(message)
end