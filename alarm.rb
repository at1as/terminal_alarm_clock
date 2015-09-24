#!/usr/bin/env ruby

require 'Time'
require 'chronic'
require 'yahoo-weather'

VALID_DATES = ["today", "tomorrow", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
HELP_FLAGS = ["help", "-h", "--help"]
USAGE = "\nWelcome to Ruby Alarm."\
        "\nUsage: $ ruby alarm.rb <day> <time> (ex. ruby alarm.rb monday 930am)"\
        "\nValid <day> options: #{VALID_DATES.join(", ")}"\
        "\nValid <time> options: hh:mm (ex. 06:15, 8:30, 1030am, 16:30, 9:20pm)\n"


location_ids = {"calgary": 8775, "montreal": 3534, "toronto": 4118, "vancouver": 9807}

reaper = Thread.new do
  loop do
    Kernel.exit if gets =~ /q/
  end
end


if !ARGV.length == 2
  puts USAGE
elsif HELP_FLAGS.include? ARGV[0].downcase or !VALID_DATES.include? ARGV[0].downcase
  puts USAGE
else

  ## Location
  if ARGV[3].nil?
    location = location_ids[:calgary]
  else
    begin
      location = location_ids[ARGV[3].to_sym]
    rescue
      location = location_ids[:calgary]
    end
  end

  ## Time Scheduler
  set_date = ARGV[0].downcase
  set_time = ARGV[1].downcase
  ring_time = Time.parse("#{Chronic.parse("#{set_date} at #{set_time}")}")

  ## For OS X ensure pmset is scheduled to wake system before alarm rings
  if RUBY_PLATFORM.include? "darwin"
    schedule = "#{ring_time.month}/#{ring_time.day}/#{ring_time.year} #{ring_time.hour}:#{ring_time.min}:00"
    `pmset schedule wake "#{schedule}"`
  end


  if Time.now > ring_time
    puts "Alarm is set in the past!"
  else
    # spawn thread to ring alarm here
    timer = Thread.new do
      while Time.now < ring_time
        puts `clear`
        puts "Current Time: \t#{Time.now} \nAlarm Set: \t#{ring_time} \nRemaining: \t#{(ring_time - Time.now).to_int} s"
        
        sleep 1
      end
    
      # Update details for current time
      @client = YahooWeather::Client.new
      
      current_weather = @client.lookup_by_woeid(location, YahooWeather::Units::CELSIUS)
      temp, details = current_weather.condition.temp, current_weather.condition.text
      city = current_weather.location.city

      puts `clear`
      puts "\nLocation : #{city}"
      puts "Temperature : #{temp}"
      puts "Details : #{details}"
      
      puts "\nPress ctrl+C to disable alarm"
      
      loop do
        hour, min = Time.now.hour, Time.now.strftime('%M')

        `say "Good Morning! "\
         "The time is #{hour} #{min}."\
         "Today's weather in #{city} is #{temp} degrees and #{details}"`
      end
    end

    # Threads
    timer.join
  end
end

# Teardown
Thread.kill(timer) if !timer.nil? and timer.alive?

