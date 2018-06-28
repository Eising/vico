Feature: Submitting a simple template

Scenario: Check if the templates page loads
          Given I am logged in as test with password test
          And I am on the templates page
          Then I should see "Manage templates"

Scenario: Check if I can enter a template
          Given I am logged in as test with password test
          And I am on the template compose page
          Then I should see "Add/Modify template"
          When I fill in the following:
            | name | Test_1 |
            | description | A Cucumber test |
            | platform | Test |
          And I fill in "up_contents" with "{{test}}"
          And I fill in "down_contents" with "{{test}}"
          And I press "Add template"
          Then I should see "Select the validation types of the tags in your template"
          When I select "No validation" from "tag.test"
          And I press "Submit"
          Then I should see "Manage templates"
          And I should see "Test_1"

Scenario: Delete the template
          Given I am logged in as test with password test
          And I delete the template called Test_1
          When I am on the templates page
          Then I should not see "Test_1"
