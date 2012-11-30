Feature: Test providers with different data types
  In Order to test different property types
  I want to run providers
  Then they should all work
  Scenario Outline: Run providers
    Given a generated provider for "samples/mof/<klass>.mof"
    When I register "samples/mof/<klass>.mof" using "<klass>.registration" with sfcb
    Then I should see "<klass>" in enumerated instance names

  Examples:
  | klass |
  | RCP_SimpleDataTypes |
  | RCP_ArrayDataTypes |
