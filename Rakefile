# frozen_string_literal: true

require 'bundler/gem_tasks'

#RELISH_PROJECT = 'trema/pio'
#FLAY_THRESHOLD = 1446
#
#task default: :travis
#task test: %i[spec cucumber]
#task travis: %i[test quality]
#
#desc 'Check for code quality'
#task quality: %i[reek flog flay rubocop]
#
#Dir.glob('tasks/*.rake').each { |each| import each }
#
#require 'pio/pcap'
#
#def dump_in_hex(data)
#  hexdump = data.unpack('C*').map do |each|
#    format('0x%02x', each)
#  end
#  puts "[#{hexdump.join(', ')}]"
#end
#
#desc 'Dump packet data file in Array'
#task :dump do
#  unless ENV['PACKET_FILE']
#    raise 'Usage: rake PACKET_FILE="foobar.{pcap,raw}" dump'
#  end
#  packet_file =
#    File.join(File.dirname(__FILE__), 'features/', ENV['PACKET_FILE'])
#  case File.extname(packet_file)
#  when '.raw'
#    dump_in_hex(IO.read(packet_file))
#  when '.pcap'
#    File.open(packet_file) do |file|
#      Pio::Pcap::Frame.read(file).records.each do |each|
#        dump_in_hex(each.data)
#      end
#    end
#  else
#    raise "Unsupported file extension: #{ENV['PACKET_FILE']}"
#  end
#end
