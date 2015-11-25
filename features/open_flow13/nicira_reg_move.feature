@open_flow13
Feature: Pio::OpenFlow::NiciraRegMove

  Copies source[source_offset:sourcce_offset+n_bits] to
  destination[destination_offset:dst_ofs+n_bits], where a[b:c] denotes
  the bits within 'a' numbered 'b' through 'c' (not including bit 'c').

  Scenario: new(source: :arp_sender_hardware_address, destination: :arp_target_hardware_address)
    When I try to create an OpenFlow action with:
      """
      Pio::OpenFlow::NiciraRegMove.new(source: :arp_sender_hardware_address,
                                       destination: :arp_target_hardware_address)
      """
    Then it should finish successfully
    And the action has the following fields and values:
      | field              |                        value |
      | n_bits             |                           48 |
      | source             | :arp_sender_hardware_address |
      | source_offset      |                            0 |
      | destination        | :arp_target_hardware_address |
      | destination_offset |                            0 |

  Scenario: new(source: :reg0, destination: :reg7)
    When I try to create an OpenFlow action with:
      """
      Pio::OpenFlow::NiciraRegMove.new(source: :reg0, destination: :reg7)
      """
    Then it should finish successfully
    And the action has the following fields and values:
      | field              | value |
      | n_bits             |    32 |
      | source             | :reg0 |
      | source_offset      |     0 |
      | destination        | :reg7 |
      | destination_offset |     0 |
      
  Scenario: new(source: :reg0, source_offset: 16, destination: :reg7, destination_offset: 16, n_bits: 16)
    When I try to create an OpenFlow action with:
      """
      Pio::OpenFlow::NiciraRegMove.new(source: :reg0, source_offset: 16,
                                       destination: :reg7, destination_offset: 16,
                                       n_bits: 16)
      """
    Then it should finish successfully
    And the action has the following fields and values:
      | field              | value |
      | n_bits             |    16 |
      | source             | :reg0 |
      | source_offset      |    16 |
      | destination        | :reg7 |
      | destination_offset |    16 |      
