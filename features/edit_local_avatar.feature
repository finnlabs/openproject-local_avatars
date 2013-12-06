Feature: Edit Local Avatar
  Background:
    Given there is 1 user with:
      | Login | bob |
    And there is 1 user with the following:
      | Login | john |


  @javascript
  Scenario: Set an invalid local avatar
    Given I am already logged in as "john"
    When I am on the my account page
    Then I should see "Change avatar" within "#menu-sidebar"
    When I click on "Change avatar"
    Then I should be on the my avatar page
    When I upload a "invalid_avatar.txt" image
    And I press "Save"
    Then I should be on the my avatar page
    And  I should see "Format allowed jpg, png, gif"

  @javascript
  Scenario: Set a valid local avatar
    Given I am already logged in as "bob"
    When I am on the my account page
    Then I should see "Change avatar" within "#menu-sidebar"
    When I click on "Change avatar"
    Then I should be on the my avatar page
    When I upload a "valid_avatar.png" image
    And I press "Save"
    Then I should be on the my account page
    And  I should see "Avatar changed successfully."

  @javascript
  Scenario: Create a ticket with user that had set an avatar
    Given there are the following project types:
      | Name                  |
      | Standard Project      |
    And there is a project named "iMate" of type "Standard Project"
    And I am already logged in as "john"
    And I am working in project "iMate"
    And there are the following work packages in project "iMate":
      | subject | start_date | due_date   | author  |
      | pe2     | 2013-01-01 | 2013-12-31 | bob     |
    When I go to the page of the planning element "pe2" of the project called "iMate"
    Then I should see ".gravatar" within ".profile-wrap"



