require 'optparse'
require_relative './football_stats_crawler/crawler'

def numeric?(number)
  Float(number) != nil rescue false
end

def one_update_loop(crawler)
  crawler.put_competitions_to_database
  crawler.put_teams_to_database
end 

puts 'Starting'

options = {}
OptionParser.new do |option|
  option.on('--api_key APIKEY') { |opt| options[:api_key] = opt }
  option.on('--wait_time WAITTIME') { |opt| options[:wait_time] = opt }
end.parse!

raise('Missing --api_key argument') unless options.has_key?(:api_key)

if options.has_key?(:wait_time)
  raise('Wait time argument has to a number') unless numeric?(options[:wait_time])
end

crawler = Crawler.new(options[:api_key])

if options.has_key?(:wait_time)
  while true
    puts 'Starting infinite update'
    one_update_loop(crawler)
    puts "Finished whole update. Next update will start in #{options[:wait_time]} minutes"
    sleep(60 * options[:wait_time].to_f)
  end
else
  puts 'Starting one update loop'
  one_update_loop(crawler)
  puts 'Finished whole update'
end

puts 'Ending'
