require_relative './football_stats_crawler/crawler'

puts 'Starting'

crawler = Crawler.new('7fc818b7d73e47d4babe4a58bb25ea81')
crawler.put_teams_to_database

puts 'Ending'
