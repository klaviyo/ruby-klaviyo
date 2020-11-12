files = ['klaviyo.gemspec', '{lib}/**/*'].map {|f| Dir[f]}.flatten

Gem::Specification.new do |s|
  s.name        = 'klaviyo'
  s.version     = '1.0.1'
  s.date        = '2020-10-20'
  s.summary     = 'You heard us, a Ruby wrapper for the Klaviyo API'
  s.description = 'Ruby wrapper for the Klaviyo API'
  s.authors     = ['Klaviyo Team', 'GetCoveredLLC Team']
  s.email       = 'hello@klaviyo.com'
  s.files       = files
  s.homepage = 'https://www.klaviyo.com/'
  s.require_path = 'lib'
  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'escape'
  s.add_dependency 'rest-client', '>= 2.0'
end
