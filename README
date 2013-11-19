Entirely trival (KISS) ical generation in Ruby

This is a tiny script I wrote some time ago to generate ICS files for English Bank Holidays (which are surprisingly rare, most people offering nonsensical "UK Holidays" calendars), distributed at http://rwec.co.uk/x/ical/

REQUIREMENTS / SETUP

Depends on a Ruby Gem called "icalendar" (gem install icalendar), which in turn I think requires Ruby >=1.9

A sample .htaccess is included in this repo for providing .ics URLs which auto-generate when you create or change the corresponding .in file.

FILE FORMAT

The input file should be named something.in and be in the same directory as the ruby script. Given the CGI argument file=somehing.in, the script will generate a corresponding something.ics file (as a cache) and serve it.

Each line of the input file represents a single event, composed of fields separated by pipe | characters:

date | title
date | title | description
> The simplest form is an all day event with a title and optional description.

date time | time | title
date time | time | title | description
> For timed events, include the start time in the first field, then the end time (without a date) as the second field.

Notes:
- Whitespace around each field is discarded, so you can align the fields into neat columns if you want. 
- Dates and times are parsed using Ruby's built-in parse method, so any reasonable format should work.
- Titles and descriptions are passed into the ical file as-is. In particular, \n will be interpretted as a newline by the receiving calendar.
- If an event starts at midnight, the script will think you didn't specify a time at all (because I'm too lazy to make it smarter). To work around this, simply specify the start time as one second past midnight instead.
- For examples of all of the above, see the provided example.in file.

TESTING

Conveniently, Ruby's CGI library will accept arguments from the input; you can test the script against the provided example.in with the following (the `touch` ensures that the script sees the example.ics file as "stale"):

touch example.in; ruby generate.rb file=example
