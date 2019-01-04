
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test_server/version"

Gem::Specification.new do |spec|
  spec.name          = "test_server_rb"
  spec.version       = TestServer::VERSION
  spec.authors       = ["Josh Bodah"]
  spec.email         = ["joshuabodah@gmail.com"]

  spec.summary       = %q{dead simple fork based test server}
  spec.homepage      = "https://github.com/jbodah/test_server"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "terminal-notifier"
end
