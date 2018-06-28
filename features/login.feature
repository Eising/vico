Feature: Logging in

Scenario: Seeing the login box
          Given I am logged in as test with password test
          Then I should see "Provision Service"
