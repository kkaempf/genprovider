Feature: Ability to register a provider with sfcb
  In Order to verify the basic functionality
  As a developer
  I want to generate a simple Ruby provider
  Then I should be able to register it with sfcb
  Scenario Outline: Register with sfcb
    When I register "<mof>" using "<registration>" with sfcb
    Then I should see "<class>" in namespace "<namespace>"

  Examples:
    | mof                      | registration           | class     | namespace |
    | features/mof/trivial.mof | Cmpi_Swig.registration | Cmpi_Swig | test/test |
