lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gen_resume/version'

Gem::Specification.new do |spec|
  spec.name          = 'gen_resume'
  spec.version       = GenResume::VERSION
  spec.authors       = ['Jon Sangster']
  spec.email         = ['jon@ertt.ca']
  spec.summary       = "Jon Sangster's resume builder"
  spec.description   = "Jon Sangster's resume builder"
  spec.homepage      = ''
  spec.license       = ''

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['genresume']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rexml', '~> 3.2'
  spec.add_dependency 'sass', '~> 3.5'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'rake', '~> 12.2'
  spec.add_development_dependency 'rubocop', '~> 0.58'

  spec.add_runtime_dependency 'slop', '~> 4.6'
end
