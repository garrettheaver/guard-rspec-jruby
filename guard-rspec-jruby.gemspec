Gem::Specification.new do |s|

  s.name        = 'guard-rspec-jruby'
  s.version     = '0.0.6'
  s.platform    = Gem::Platform::RUBY

  s.authors     = ['Garrett Heaver']
  s.email       = ['garrett@iterationfour.com']
  s.homepage    = 'http://github.com/garrettheaver/guard-rspec-jruby'
  s.description = 'A Guard::RSpec extension to improve performance on JRuby'
  s.summary     = 'Guard::RSpec JRuby extension'

  s.add_dependency 'rspec'
  s.add_dependency 'guard'
  s.add_dependency 'guard-rspec'

  s.files = Dir.glob('lib/**/*') + %w[LICENCE]
  s.require_path = 'lib'

end
