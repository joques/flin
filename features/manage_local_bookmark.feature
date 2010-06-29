Feature: Manage local bookmarks

	As a user
	I want to store local bookmarks
	So that I can  visit the urls later in the future
	
	Scenario: User successfully adds a new bookmark entry
		Given the entry title behavior driven development does not exist
		When I add-new with entry title behavior driven development and entry url http://www.bdd.org
		Then I should see a message "New entry successfully added"
	