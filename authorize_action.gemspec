# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "authorize_action"
  spec.version       = "1.1.0"
  spec.authors       = ["Jarmo Pertman"]
  spec.email         = ["jarmo.p@gmail.com"]
  spec.description   = %q{Really secure and simple authorization library for your Rails, Sinatra or whatever web framework, which doesn't suck.}
  spec.summary       = %q{Really secure and simple authorization library.}
  spec.homepage      = "https://github.com/jarmo/authorize_action"
  spec.license       = "MIT"

  spec.cert_chain    = ["certs/jarmo.pem"]
  spec.signing_key   = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
end
