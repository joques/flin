Given /^the bookmark entries$/ do
  @bookmark.should_not be_nil
end

Given /^the entry title (.*) does not exist$/ do |title|
  Given "the bookmark entries"
  @bookmark.exists_entry_with_title?(title).should be_false
end

Given /^the entry title (.*) exists$/ do |title|
  Given "the bookmark entries"
  @bookmark.exists_entry_with_title?(title).should be_true
end

Given /^the title (.*) is associated with the url (.*)$/ do |title, url| 
  @bookmark.entries[title.downcase].should_not be_nil
  @bookmark.is_url_paired_with_title?(title,url).should be_true
end

Given /^the title (.*) is not associated with the url (.*)$/ do |title, url| 
  @bookmark.entries[title.downcase].should_not be_nil
  @bookmark.is_url_paired_with_title?(title,url).should be_false
end

When /^I get entry with title (.*)$/ do |title|
  @response = @bookmark.get(title)
end

When /^I update entry title (.*) with new url (.*) where url is (.*)$/ do |title, new_url, old_url|
  @response = @bookmark.update(title, old_url, new_url)
end

When /^I delete entry title (.*) where url is (.*)$/ do |title, url|
  @response = @bookmark.delete(title, url)
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

Then /^I should see the url (.*)$/ do |url|
  @response.should eql(url)
end

