Entirely trival (KISS) ical generation in Ruby

This is a tiny script I wrote some time ago to generate ICS files for English Bank Holidays (which are surprisingly rare, most people offering nonsensical "UK Holidays" calendars), distributed at http://rwec.co.uk/x/ical/

REQUIREMENTS / SETUP

Depends on a Ruby Gem called "icalendar" (gem install icalendar), which in turn I think requires Ruby >=1.9

A sample .htaccess is included in this repo for providing .ics URLs which auto-generate when you create or change the corresponding .in file.

FILE FORMAT

The input file should be named something.in and be in the same directory as the ruby script. Given the CGI argument file=somehing.in, the script will generate a corresponding something.ics file (as a cache) and serve it.

Each line of the input file should have a date (in any reasonably parseable format), a single pipe character | followed by the name of the event.

That's it.
