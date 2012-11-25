Feature: Test providers with known instances
  In Order to test providers known to have instances
  As a developer
  I want to enumerate instances
  Then I should get a non-zero instance count
  Scenario Outline: Enumerate instances
    Given a generated provider for "samples/mof/<class>.mof"
    And I register "samples/mof/<class>.mof" using "<class>.registration" with sfcb
    And "<class>" is registered in namespace "test/test"
    Then I should see "<class>" in enumerated instance names

  Examples:
    | class |
    | RCP_ComputerSystem |
    
#    | RCP_OperatingSystem|
#    | RCP_PhysicalMemory |
#    | RCP_Processor      |
#    | RCP_RunningOS      |
#    | RCP_UnixProcess    |
