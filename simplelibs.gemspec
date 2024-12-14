require_relative 'lib/simplelibs'

Gem::Specification.new do |s|
  s.name        = 'simplelibs'
  s.platform    = Gem::Platform::RUBY
  s.version     = Simplelibs::VERSION
  s.summary     = 'Collection of helpful ruby libraries'
  s.description = 'Simplifies many common funcionalities of ruby projects by providing lightweight standardized classes'
  s.authors     = ['Daniel Silvestre']
  s.email       = 'danibas@hotmail.com'
  s.homepage    = 'https://github.com/djlebersilvestre/simplelibs'
  s.license     = 'Apache 2.0'
  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
end
