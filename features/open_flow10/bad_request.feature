@open_flow10
Feature: Error::BadRequest

  Request was not understood error.

  Scenario: new (raw_data = Echo request 1.3)
    When I try to create an OpenFlow message with:
      """
      Pio::OpenFlow::Error::BadRequest.new(raw_data: Pio::OpenFlow13::Echo::Request.new.to_binary)
      """
    Then it should finish successfully
    And the message has the following fields and values:
      | field           |        value |
      | ofp_version     |            1 |
      | message_type    |            1 |
      | message_length  |           20 |
      | transaction_id  |            0 |
      | xid             |            0 |
      | error_type      | :bad_request |
      | error_code      | :bad_version |
      | raw_data.length |            8 |

  Scenario: read
    When I try to parse a file named "open_flow10/bad_request.raw" with "Pio::OpenFlow::Error::BadRequest" class
    Then it should finish successfully
    And the message has the following fields and values:
      | field           |        value |
      | ofp_version     |            1 |
      | message_type    |            1 |
      | message_length  |           20 |
      | transaction_id  |            0 |
      | xid             |            0 |
      | error_type      | :bad_request |
      | error_code      | :bad_version |
      | raw_data.length |            8 |
