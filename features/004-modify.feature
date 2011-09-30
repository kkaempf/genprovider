Feature: Ability to parse a mof and create a template
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to access it using ruby-sfcc
  Scenario: Change an instance
    Given an instance of "Cmpi_Swig" with property "hello" set to "Hello world"
    When I change the property "hello" to "Goodbye, cruel world"
    Then the instance of "Cmpi_Swig" should have property "hello" set to "Goodbye, cruel world"
