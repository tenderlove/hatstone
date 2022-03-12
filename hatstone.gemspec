# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hatstone"
  spec.version       = "1.0.0"
  spec.authors       = ["Aaron Patterson"]
  spec.email         = ["tenderlove@ruby-lang.org"]

  spec.summary       = %q{A wrapper around Capstone for Ruby.}
  spec.description   = %q{A Capstone wrapper for Ruby.}
  spec.homepage      = "https://github.com/tenderlove/hatstone"
  spec.licenses      = ["Apache-2.0"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ["lib"]
  spec.extensions = ["ext/hatstone/extconf.rb"]

  spec.add_development_dependency "rake", '~> 13.0'
  spec.add_development_dependency "rake-compiler", '~> 1.1'
  spec.add_development_dependency "minitest", '~> 5.15'
end
