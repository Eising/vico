Feature: Create a template, form, and provision it

Scenario: Provision the service
          Given I am logged in as test with password test
          And I create a service called "Test_form" containing:
              | field1 | Field1 |
              | field2 | Field2 |
          And I am on the home page
          And I fill in the following:
              | reference | testref |
              | node | node1 |
              | customer | customer1 |
              | location | somewhere |
              | product | product1 |
          And I select "Test_form" from "form_id"
          And I follow "Next"
          Then I should see "Configure Service"
          And I should see "Field1"
          And I should see "Field2"
          When I fill in "form.field1" with "TestVal1"
          And I fill in "form.field2" with "TestVal2"
          And I press "Submit"
          Then I should see "TestVal1"
