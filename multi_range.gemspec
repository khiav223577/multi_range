# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_range/version'

Gem::Specification.new do |spec|
  spec.name          = 'multi_range'
  spec.version       = MultiRange::VERSION
  spec.authors       = ['khiav reoy']
  spec.email         = ['mrtmrt15xn@yahoo.com.tw']

  spec.summary       = 'Allow you to manipulate a group of ranges.'
  spec.description   = 'Allow you to manipulate a group of ranges. Such as merging overlapping ranges, doing ranges union, intersection, difference, and so on.'
  spec.homepage      = 'https://github.com/khiav223577/multi_range'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject{|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}){|f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata      = {
    'homepage_uri'      => 'https://github.com/khiav223577/multi_range',
    'changelog_uri'     => 'https://github.com/khiav223577/multi_range/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/khiav223577/multi_range',
    'documentation_uri' => 'https://www.rubydoc.info/gems/multi_range',
    'bug_tracker_uri'   => 'https://github.com/khiav223577/multi_range/issues',
  }

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3.x'
  spec.add_development_dependency 'rake', '>= 10.5.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'backports', '~> 3.15.0'
  spec.add_development_dependency 'activesupport', '~> 7.0'

  spec.add_dependency 'roulette-wheel-selection', '~> 1.1.1'
  spec.add_dependency 'fast_interval_tree', '~> 0.2.0'
end
