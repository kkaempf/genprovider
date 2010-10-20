Feature: Ability to parse a mof and create a template
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to read it
  And I should be able to get it compiled
  And I should be able to register it with sfcb
  And I should be able to access it using ruby-sfcc
  Scenario: Run genprovider
    Given nothing
    When I run genprovider with no arguments
    Then I should see an error message
    Given nothing
    When I run genprovider with "-h"
    Then I should see a short usage explanation
  Scenario: Ensure correct output format and compilation
    Given I have a mof file called "trivial.mof"
    When I pass "trivial.mof" to genprovider
    Then comment lines should not exceed 75 characters
    And its output should be accepted by Ruby
  Scenario: Register with sfcb
    Given I have a registration "cmpi_swig.registration"
    When I register this with sfcb
    Then I should see "Cmpi_Swig" in enumerated class names
    And I should see "Cmpi_Swig" in namespace "test/test"
  Scenario: Create an instance
    Given "Cmpi_Swig" is registered
    When I create an instance of "Cmpi_Swig" with "hello" set to "Hello, world"
    Then I should see "Cmpi_Swig" in enumerated instance names
    And the instance of "Cmpi_Swig" should have property "hello" set to "Hello, world"
  Scenario: Change an instance
    Given an instance of "Cmpi_Swig" with property "hello" set to "Hello, world"
    When I change the property "hello" to "Goodbye, cruel world"
    Then the instance of "Cmpi_Swig" should have property "hello" set to "Goodbye, cruel world"
  Scenario: Delete an instance
    Given an instance of "Cmpi_Swig" with property "hello" set to "Hello, world"
