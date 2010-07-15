Feature: Save and sync bookmarks

	As a user
	I want to save and sync local bookmarks
	So that I can  share them with other computers or users
	
	Scenario: User successfully saves local bookmarks
		Given the bookmark entries are not empty
		When I save to local store
		Then I should see a message Bookmark entries successfully stored locally!