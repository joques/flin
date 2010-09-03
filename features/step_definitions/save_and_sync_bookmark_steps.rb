# I need to reuse the Given bookmark step. In the mean time I just reuse the
# same definition here

Given /^the bookmark entries are not empty$/ do
  @bookmark.should_not be_nil
  @bookmark.entries.should_not be_empty
end

When /^I save to local store$/ do
  @response = @bookmark.save
end

When /^I sync with database$/ do
  @response = @bookmark.sync_db
end