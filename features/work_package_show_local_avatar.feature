Feature: Check if local avatar was set
  Background:
    Given there is 1 user with:
      | Login | bob  |

#  @javascript
  Scenario: Create a ticket with user that had set an avatar
    Given there are the following project types:
      | Name                  |
      | Standard Project      |
    And there is a project named "iMate" of type "Standard Project"
    Given I am logged in with user "bob" that has an avatar
    And I am working in project "iMate"
    And there are the following work packages in project "iMate":
      | subject | start_date | due_date   | author  |
      | pe2     | 2013-01-01 | 2013-12-31 | bob     |

    When I am already admin
    And  I go to the page of the planning element "pe2" of the project called "iMate"
    Then I should see local avatar inside "profile-wrap"