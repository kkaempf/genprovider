Feature: Run genprovider
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to get it compiled
  Scenario: Run genprovider
    When I run genprovider with no arguments
    Then I should see an error message
    When I run genprovider with "-h"
    Then I should see a short usage explanation
