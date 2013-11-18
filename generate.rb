#!/usr/bin/ruby -w

# Path to custom-installed Ruby Gems
require 'rubygems'
require 'date'
require 'cgi'
require 'icalendar'

cgi = CGI.new

begin
	in_file = "#{File.basename(cgi['file'])}.in"
	out_file = "#{File.basename(cgi['file'])}.ics"
	
	# Check that the input file exists
	if ! File.readable? in_file
	
		cgi.out('status' => 'NOT_FOUND', 'type' => 'text/plain') { 'No such file' }
	
	# See if the output file already exists, and is new enough
	elsif File.exist?(out_file) && ( File.mtime(out_file) > File.mtime(in_file) )
	
		ics_file = File.new(out_file, 'r')
		cgi.out( cgi['send_plain'] == 'true' ? 'text/plain' : 'text/calendar' ) { ics_file.read }
		ics_file.close
		
	# Retrieve the dates from the input file
	else
		dates = []
		
		File.open(in_file, 'r') do |infile|
			while (line = infile.gets)
				dates.push line.strip.split '|'
			end
		end
		
		# Generate the calendar
		include Icalendar
		
		cal = Calendar.new
		
		dates.each { |event|
			cal.event do
				dtstart       Date.parse event[0].strip
				dtend         dtstart + 1
				summary       event[1].strip
			end
		}
		
		ics_file = File.new(out_file, 'w')
		ics_file.write cal.to_ical
		ics_file.close
		
		cgi.out( cgi['send_plain'] == 'true' ? 'text/plain' : 'text/calendar' ) { cal.to_ical }
	end

rescue Exception => err
	cgi.out( 'text/plain' ) { "Exception: #{err}" }
end
