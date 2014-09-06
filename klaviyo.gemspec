files = ['klaviyo.gemspec', '{lib}/**/*'].map {|f| Dir[f]}.flatten

Gem::Specification.new do |s|
  s.name        = 'klaviyo'
  s.version     = '1.0.0'
  s.date        = '2014-09-06'
  s.summary     = 'You heard us, a Ruby wrapper for the Klaviyo API'
  s.description = 'Ruby wrapper for the Klaviyo API'
  s.authors     = ['Klaviyo Team']
  s.email       = 'hello@klaviyo.com'
  s.files       = files
  s.homepage = 'https://www.klaviyo.com/'
  s.require_path = 'lib'
  s.has_rdoc    = false
  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'escape'
end