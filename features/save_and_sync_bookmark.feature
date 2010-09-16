Feature: Save and sync bookmarks

	As a user
	I want to save and sync local bookmarks
	So that I can  share them with other computers or users
	
	Scenario: User successfully saves local bookmarks
		Given the bookmark entries are not empty
		When I save to local store
		Then I should see a message Bookmark entries successfully stored locally!
		
	Scenario: User successfully syncs local bookmarks with database
		Given the bookmark entries are not empty
		When I sync with database with port 11211 and host 10.0.1.2
		Then I should see a message Local bookmarks successfully synced with database!