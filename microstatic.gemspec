# -*- encoding: utf-8 -*-
require File.expand_path('../lib/microstatic/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Pete Hodgson"]
  gem.email         = ["phodgson@thoughtworks.com"]
  gem.description   = %q{The microstatic gem turns generating your static site and deploying it to S3 into a one-liner.}
  gem.summary       = %q{Generate static sites from git and deploy them to an S3 bucket.}
  gem.homepage      = "https://github.com/moredip/microstatic"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "microstatic"
  gem.require_paths = ["lib"]
  gem.version       = Microstatic::VERSION

  gem.add_runtime_dependency "fog", ">=1"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~>2.13.0"
  gem.add_development_dependency "pry-nav", "~> 0.2.3"
end
