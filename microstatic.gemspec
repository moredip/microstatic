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
end
