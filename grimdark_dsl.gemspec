
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grimdark_dsl/version"

Gem::Specification.new do |spec|
  spec.name          = "grimdark_dsl"
  spec.version       = GrimdarkDsl::VERSION
  spec.authors       = ["Pat Wilson"]
  spec.email         = ["zerostride@gmail.com"]

  spec.summary       = "A DSL for defining data resources in the grim dark future."
  spec.homepage      = "https://github.com/ZeroStride/GrimdarkDsl"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
