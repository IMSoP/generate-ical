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
			start_datetime = DateTime.parse event[0].strip

			# Detect if this is a whole day or timed event
			if start_datetime == start_datetime.to_date
				# Time is midnight, so assume whole day event
				cal.event do
					dtstart       start_datetime.to_date
					dtend         start_datetime.to_date + 1
					summary       event[1].strip
					if event[2]
						description   event[2].strip
					end
				end
			else
				# Assume a separate end time will be provided
				# (There must be a better way of saying "this date at this other time"
				#	than concatenating their string values, surely?)
				end_datetime = DateTime.parse( start_datetime.to_date.to_s + ' ' + event[1].strip )
				# Events crossing midnight need special consideration
				if end_datetime < start_datetime
					end_datetime += 1
				end

				cal.event do
					dtstart       start_datetime
					dtend         end_datetime
					summary       event[2].strip
					if event[3]
						description   event[3].strip
					end
				end
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
