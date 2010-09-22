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
		When I add new entry with title help haiti and url http://helphaiti.net
		Then I should see a message Bookmark entry successfully extended!
		
	Scenario: User successfully updates an entry
		Given the entry title help haiti exists
		And the title help haiti is associated with the url http://helphaiti.org
		When I update entry title help haiti with new url http://shinninghaiti.org where url is http://helphaiti.org
		Then I should see a message Bookmark entry successfully updated!
		
	Scenario: User unsuccessfully updates an entry with wrong title
		Given the entry title another rake tutorial does not exist
		When I update entry title another rake tutorial with new url http://anotherraketutorial.com where url is http://raketutorial.info
		Then I should see a message Sorry! There is no bookmark entry with this title
		
	Scenario: User unsuccessfully updates an entry with wrong url
		Given the entry title help haiti exists
		And the title help haiti is not associated with the url http://abrighthaiti.org
		When I update entry title help haiti with new url http://shinninghaiti.org where url is http://abrighthaiti.org
		Then I should see a message Sorry! The old url has never been attached to the title
		
	Scenario: User successfully deletes an entry
		Given the entry title agile data exists
		And the title agile data is associated with the url http://www.agiledata.org/
		When I delete entry title agile data where url is http://www.agiledata.org
		Then I should see a message Bookmark entry successfully deleted!

	Scenario: User unsuccessfully deletes an entry with wrong title
		Given the entry title agiledata does not exist
		When I delete entry title agiledata where url is http://www.agiledata.org
		Then I should see a message Sorry! There is no bookmark entry with this title

	Scenario: User unsuccessfully deletes an entry with wrong url
		Given the entry title agile data exists
		And the title agile data is not associated with the url http://towardsagile.com
		When I delete entry title agile data where url is http://towardsagile.com
		Then I should see a message Sorry! The url has never been attached to the title
		
	Scenario: User successfully views an entry
		Given the entry title agile data exists
		When I get entry with title agile data
		Then I should see the url http://www.agiledata.org/
		
	Scenario: User unsuccessfully views an entry
		Given the entry title agiledata does not exist
		When I get entry with title agiledata
		Then I should see a message Sorry! There is no bookmark entry with this title