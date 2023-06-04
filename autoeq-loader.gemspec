Gem::Specification.new do |s|
  s.name          = 'autoeq_loader'
  s.version       = '0.1'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'

  s.summary       = %q{Loads AutoEQ measurements and makes audio filters}
  s.description   = %q{AutoEQLoader loads AutoEQ measurements and makes audio filters.}
  s.homepage      = 'http://github.com/jslabovitz/autoeq_loader'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_development_dependency 'bundler', '~> 2.4'
  s.add_development_dependency 'minitest', '~> 5.18'
  s.add_development_dependency 'minitest-power_assert', '~> 0.3'
  s.add_development_dependency 'rake', '~> 13.0'
end