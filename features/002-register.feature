Feature: Ability to parse a mof and create a template
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to register it with sfcb
  Scenario: Register with sfcb
    When I register "trivial.mof" using "cmpi_swig.registration" with sfcb
    Then I should see "Cmpi_Swig" in namespace "test/test"
