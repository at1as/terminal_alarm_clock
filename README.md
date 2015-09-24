# Terminal Alarm Clock

Terminal Alarm Clock is a simple OS X alarm clock. Launch from the command line, and be awoken at the specified time with a weather report for your region.

## Screens

Countdown:
```bash
Current Time:   2015-09-24 19:16:00 -0400 
Alarm Set:  2015-09-24 19:17:00 -0400 
Remaining:  59 s
```

Alarm Ringing:
```bash
Location : Calgary
Temperature : 15
Details : Mostly Cloudy

Press ctrl+C to disable alarm
```

## Installation

To install all necessary packages:
```bash
$ git clone https://github.com/at1as/terminal_alarm_clock.git
$ gem install chronic
$ gem install yahoo-weather
```

The unmaintained yahoo-weather gem has Ruby syntax that is invalid in Ruby 2.0+. To fix this:

Manually:
* Locate the source ($ gem which yahoo-weather)
* Find the yahoo-weather/atmosphere.rb file along that path
* Replace when 0:, when 1:, when 2: to change the colon for a line break

Script:
```bash
$ GEM_LOC=$(gem which yahoo-weather)
$ FILE_LOC=$(echo "$(echo $GEM_LOC | sed 's/\.rb$//g')/atmosphere.rb")
$ awk '{gsub(": @", "\n@");}1;' $FILE_LOC > tmp && mv tmp $FILE_LOC
```

Other:
* Replace yahoo-weather with https://github.com/at1as/yahoo-weather
 
## Usage
 
To start:
```bash
$ sudo ruby alarm.rb tomorrow 9:30am
```

To stop:
```bash
$ ctrl+C
```
 
## Disclaimers
 
* Developed, tested and intended to be used on Mac OS X (using pmset scheduler)
* pmset requires sudo privilages. If you don't call the script with sudo and your system goes to sleep, it may not wake for the alarm to ring
* I personally wouldn't rely on this script, but it's a handy backup alarm clock for when you're traveling or have something important the next day

