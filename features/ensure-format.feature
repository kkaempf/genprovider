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
    | mof                                |
    | features/mof/trivial.mof           |
    | samples/mof/qualifiers.mof         |
    | samples/mof/RCP_ArrayDataTypes.mof |
    | samples/mof/RCP_ClassMethod.mof    |
    | samples/mof/RCP_ComplexMethod.mof  |
    | samples/mof/RCP_ComputerSystem.mof |
    | samples/mof/RCP_OperatingSystem.mof|
    | samples/mof/RCP_OSProcess.mof      |
    | samples/mof/RCP_PhysicalMemory.mof |
    | samples/mof/RCP_Processor.mof      |
    | samples/mof/RCP_RunningOS.mof      |
    | samples/mof/RCP_SimpleClass.mof    |
    | samples/mof/RCP_SimpleDataTypes.mof|
    | samples/mof/RCP_SimpleMethod.mof   |
    | samples/mof/RCP_UnixProcess.mof    |
