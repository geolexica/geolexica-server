# (c) Copyright 2020 Ribose Inc.
#

require_relative "lib/geolexica_server/version"

all_files_in_git = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

ribose_url = "https://open.ribose.com/"
github_url = "https://github.com/geolexica/geolexica-server"

Gem::Specification.new do |spec|
  spec.name          = "geolexica-server"
  spec.version       = GeolexicaServer::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "Server for Geolexica sites"
  spec.homepage      = ribose_url
  spec.license       = "MIT"

  spec.metadata      = {
    "bug_tracker_uri" => "#{github_url}/issues",
    "homepage_uri" => ribose_url,
    "source_code_uri" => github_url
  }

  spec.files = all_files_in_git.reject do |f|
    [
      f.match(%r{^(test|spec|features|.github)/}),
      f.match(%r{^\.})
    ].any?
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll-geolexica"
  spec.add_dependency "mercenary"
  spec.add_dependency "relaton"

  # Zeitwerk::Loader#push_dir supports :namespace argument from v. 2.4.
  spec.add_runtime_dependency "zeitwerk", "~> 2.4"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", ">= 10"
  spec.add_development_dependency "rspec", "~> 3.9"
end
