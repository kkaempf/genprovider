Feature: Ability to parse a mof and create a template
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to get it compiled
  Scenario: Run genprovider
    When I run genprovider with no arguments
    Then I should see an error message
    When I run genprovider with "-h"
    Then I should see a short usage explanation
  Scenario: Ensure correct output format and compilation
    Given I have a mof file called "trivial.mof"
    When I pass "trivial.mof" to genprovider
    Then comment lines should not exceed 75 characters
    And its output should be accepted by Ruby
