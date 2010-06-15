#!/usr/bin/ruby
require 'rubygems'
require 'optparse'
require 'serialport'

options = {
	:device => "/dev/ttyUSB2",
	:baud => 9600,
	:data_bits => 8,
	:stop_bits => 1,
	:parity => SerialPort::NONE,
	:timeout => 5
}

op = OptionParser.new do |opts|
  opts.banner = "Usage: fsserial [options] [XX XX XX XX]"
  opts.on("--device=DEVICE", String, "Device ('/dev/ttyUSB2')") {|o| options[:device] = o}
  opts.on("--baud=BAUD", Integer, "Baud (9600)") 								{|o| options[:baud] = o}
  opts.on("--data_bits=DATA_BITS", Integer, "Data Bits (8)") 		{|o| options[:data_bits] = o}
  opts.on("--stop_bits=STOP_BITS", Integer, "Stop Bits (1)") 		{|o| options[:stop_bits] = o}
  opts.on("--parity=PARITY", Integer, "Parity (None)") 					{|o| options[:parity] = o}
  opts.on("--timeout=TIMEOUT", Integer, "Timeout (5 seconds)") 	{|o| options[:timeout] = o}
  opts.separator ""
  opts.separator "Common options:"
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
  opts.on_tail("--version", "Show version") do
		puts "Kasper Bjørn Nielsen (s052808@student.dtu.dk)"
    exit
  end
end
op.parse!



sp = SerialPort.new(DEVICE, options[:baud], options[:data_bits], options[:stop_bits], options[:parity])

ARGV.each do |s|
	sp.putc s.hex
	sleep(0.2)
end

r = []
t = Thread.new do
	4.times {r << sp.getc}
	puts r.map {|c| c.to_i.to_s(16)}.join(" ")
	exit(0)
end

sleep(options[:timeout])
t.kill!
puts "Timeout!"
exit(1)
