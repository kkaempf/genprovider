Feature: Ensure genprovider output format
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to get it compiled
  Scenario Outline: Ensure correct output format and compilation
    Given I have a mof file called "<mof>"
    When I pass "<mof>" to genprovider
    Then comment lines should not exceed 75 characters
    And its output should be accepted by Ruby

  Examples:
    | mof                      |
    | features/mof/trivial.mof |
