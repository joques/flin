Feature: Manage local bookmarks

	As a user
	I want to store local bookmarks
	So that I can  visit the urls later in the future
	
	Scenario: User successfully adds a new bookmark entry
		Given the entry title behavior driven development does not exist
		When I add new entry with title behavioral equivalence, entry url http://www.bdd.org and option new
		Then I should see a message New bookmark entry successfully added!

	Scenario: User unsuccessfully adds a new bookmark entry
		Given the entry title agile data exists
		When I add new entry with title agile data, entry url http://www.bdd.org and option new
		Then I should see a message Sorry! A bookmark entry with this title already exists!
	
	Scenario: User successfully extends a bookmark entry
		Given the bookmark entries
		When I add new entry with title Haiti and url http://helphaiti.org
		Then I should see a message Bookmark entry successfully extended!
		
	Scenario: User successfully updates an entry
		Given the entry title rake tutorial exists
		And the title rake tutorial is associated with the url http://svarovsky-thomas.com/rake.html
		When I update entry title rake tutorial with new url http://svarovsky-tomas.com/rake.html where url is http://svarovsky-thomas.com/rake.html
		Then I should see a message Bookmark entry successfully updated!