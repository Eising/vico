Feature: Create a form

Scenario: Check if the forms page loads
          Given I am logged in as test with password test
          And I am on the forms page
          Then I should see "Manage forms"

Scenario: Check if the forms compose page loads
          Given I am logged in as test with password test
          And I am on the form compose page
          Then I should see "Add new form"

Scenario: Check if I can see a created template on the forms page
          Given I am logged in as test with password test
          And I am on the template compose page
          When I fill in the following:
               | name | Form_test_1 |
               | description | A forms test |
               | platform | Test |
          And I fill in "up_contents" with "{{test}}"
          And I fill in "down_contents" with "{{test}}"
          And I press "Add template"
          And I select "No validation" from "tag.test"
          And I press "Submit"
          And I am on the form compose page
          Then I should see "Form_test_1" within "select"

Scenario: Configure a form
          Given I am logged in as test with password test
          And I am on the form compose page
          When I fill in "name" with "Test_form_1"
          And I select "Form_test_1" from "templates[]"
          And I press "Submit"
          Then I should see "Configure form"
          When I fill in the following:
               | name.test | Test |
               | default.test | 123 |
          And I press "Submit"
          Then I should see "Test_form_1"

Scenario: Delete the form and delete the template
          Given I am logged in as test with password test
          Then I go to the forms page
          And I delete the template called Form_test_1
          And I delete the form called Test_form_1
          When I am on the forms page
          Then I should not see "Test_form_1"
