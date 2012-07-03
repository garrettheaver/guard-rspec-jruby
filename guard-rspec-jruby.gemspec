Gem::Specification.new do |s|

  s.name     = 'guard-rspec-jruby'
  s.version  = '0.0.3'
  s.platform = Gem::Platform::RUBY

  s.authors  = ['Garrett Heaver']
  s.email    = ['garrett@iterationfour.com']
  s.homepage = 'http://github.com/garrettheaver/guard-rspec-jruby'
  s.summary  = 'A Guard::RSpec extension to improve performance on JRuby'

  s.add_dependency 'rspec'
  s.add_dependency 'guard'
  s.add_dependency 'guard-rspec'

  s.files = Dir.glob('lib/**/*')
  s.require_path = 'lib'

end
