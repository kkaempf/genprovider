Feature: Show CMPIContext passed to provider
  In Order to view the CMPIContext passed to the provider by the CIMOM
  As a developer
  I want to run the rcp_show_context provider
  Then I should get an array of key, value pairs
  Scenario: Run rcp_show_context
    Given a generated provider for "samples/mof/RCP_ShowContext.mof"
    And I register "samples/mof/RCP_ShowContext.mof" using "RCP_ShowContext.registration" with sfcb
    Then I should see "RCP_ShowContext" in enumerated instance names
