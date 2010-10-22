Feature: Ability to parse a mof and create a template
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to access it using ruby-sfcc
  Scenario: Create an instance
    Given "Cmpi_Swig" is registered in namespace "test/test"
    When I create an instance of "Cmpi_Swig" with "hello" set to "Hello world"
    Then I should see "Cmpi_Swig" in enumerated instance names
    And the instance of "Cmpi_Swig" should have property "hello" set to "Hello world"
