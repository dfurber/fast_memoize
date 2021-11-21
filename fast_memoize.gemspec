
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fast_memoize/version"

Gem::Specification.new do |spec|
  spec.name          = "fast_memoize"
  spec.version       = FastMemoize::VERSION
  spec.authors       = ["David Furber"]
  spec.email         = ["furberd@gmail.com"]

  spec.summary       = %q{Memoize the return values of instance methods.}
  spec.description   = %q{If you are used to doing memoization with `@my_method ||= yada_yada` and `return @my_method if defined?(@my_method); @my_method = yada_yada`, but you would like to get the memoization stuff out of the `yada_yada` part, but still rest assured that the `memoize` method does nothing more than that, then this gem is for you.}
  spec.homepage      = "https://github.com/dfurber/fast_memoize"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://github.com"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/dfurber/fast_memoize"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">=2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
