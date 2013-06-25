# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cinch-forecast'
  spec.version       = File.new('VERSION', 'r').read.chomp
  spec.authors       = ['Jonah Ruiz']
  spec.email         = ['jonah@pixelhipsters.com']
  spec.description   = %q{Forecast is a Cinch plugin for getting the weather forecast}
  spec.summary       = %q{Cinch plugin for getting the weather forecast by zipcode}
  spec.homepage      = 'https://github.com/jonahoffline/cinch-forecast'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'cinch', '~> 2.0.5'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
