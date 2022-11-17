Gem::Specification.new do |s|
  s.name = 'football_stats'
  s.version     = '0.1.0'
  s.author      = 'Jan Levy'
  s.email       = 'levyjan2@fit.cvut.cz'

  s.summary     = 'CLI app for football match stats'

  s.files       = Dir['bin/*', 'lib/**/*', '*.gemspec', 'LICENSE*', 'README*']
  s.executables = Dir['bin/*'].map { |f| File.basename(f) }

  s.required_ruby_version = '>= 3.1'

  s.add_runtime_dependency 'thor', '~> 1.2'
  s.add_development_dependency 'webmock', '~> 2.0'
end
