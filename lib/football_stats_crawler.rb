require_relative './football_stats_crawler/crawler_class'

puts 'Starting'

crawler = Crawler.new
crawler.test('My message')

puts 'Ending'
