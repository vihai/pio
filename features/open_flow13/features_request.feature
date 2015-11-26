@open_flow13
Feature: Features::Request
  Scenario: new
    When I try to create an OpenFlow message with:
      """
      Pio::OpenFlow::Features::Request.new
      """
    Then it should finish successfully
    And the message has the following fields and values:
      | field          | value |
      | ofp_version    |     4 |
      | message_type   |     5 |
      | message_length |     8 |
      | transaction_id |     0 |
      | xid            |     0 |
      | body           |       |

  Scenario: new(transaction_id: 123)
    When I try to create an OpenFlow message with:
      """
      Pio::OpenFlow::Features::Request.new(transaction_id: 123)
      """
    Then it should finish successfully
    And the message has the following fields and values:
      | field          | value |
      | ofp_version    |     4 |
      | message_type   |     5 |
      | message_length |     8 |
      | transaction_id |   123 |
      | xid            |   123 |
      | body           |       |

  Scenario: read
    When I try to parse a file named "open_flow13/features_request.raw" with "Pio::OpenFlow::Features::Request" class
    Then it should finish successfully
    And the message has the following fields and values:
      | field          | value |
      | ofp_version    |     4 |
      | message_type   |     5 |
      | message_length |     8 |
      | transaction_id |     0 |
      | xid            |     0 |
      | body           |       |
