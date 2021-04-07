files = ['klaviyo.gemspec', '{lib}/**/**/*'].map {|f| Dir[f]}.flatten

Gem::Specification.new do |s|
  s.name        = 'klaviyo'
  s.version     = '2.0.5'
  s.date        = '2021-04-05'
  s.summary     = 'You heard us, a Ruby wrapper for the Klaviyo API'
  s.description = 'Ruby wrapper for the Klaviyo API'
  s.authors     = ['Klaviyo Team']
  s.email       = 'libraries@klaviyo.com'
  s.files       = files
  s.homepage = 'https://www.klaviyo.com/'
  s.require_path = 'lib'
  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'escape'
  s.add_dependency 'faraday'
end
