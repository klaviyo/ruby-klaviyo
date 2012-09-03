files = ['klaviyo.gemspec', '{lib}/**/*'].map {|f| Dir[f]}.flatten

Gem::Specification.new do |s|
  s.name        = 'klaviyo'
  s.version     = '0.9.2'
  s.date        = '2012-09-03'
  s.summary     = 'You heard us, a Ruby wrapper for the Klaviyo API'
  s.description = 'Ruby wrapper for the Klaviyo API'
  s.authors     = ['Andrew Bialecki']
  s.email       = 'andrew@klaviyo.com'
  s.files       = files
  s.homepage = 'http://www.klaviyo.com/'
  s.require_path = 'lib'
  s.has_rdoc    = false
  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'escape'
end