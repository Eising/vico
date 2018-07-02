Feature: Test inventories CRUD

Scenario: Create inventory
          Given I am logged in as test with password test
          And I create an inventory called "test" containing:
              | Field1 | Field2 | Field3 |
              | Foo | Bar | Baz |
              | Fumble | Bumble | Braz |
          When I go to the inventory called "test"
          Then I should see "Bumble" within "table"

Scenario: Delete row in inventory
          Given I am logged in as test with password test
          And I create an inventory called "test" containing:
              | Field1 | Field2 | Field3 |
              | Foo | Bar | Baz |
              | Fumble | Bumble | Braz |
          When I go to the inventory called "test"
          Then I should see "Bumble" within "table"
          When I delete the row containing "Bumble" on inventory "test"
          Then I should not see "Bumble" within "table"

Scenario: Delete an inventory
          Given I am logged in as test with password test
          And I create an inventory called "DeleteScenarioInventory" containing:
              | Field1 | Field2 | Field3 |
              | Foo | Bar | Baz |
              | Fumble | Bumble | Braz |
          When I go to the inventories page
          Then I should see "DeleteScenarioInventory"
          When I delete the inventory "DeleteScenarioInventory"
          And I go to the inventories page
          Then I should not see "DeleteScenarioInventory"
