# frozen_string_literal: true

require_relative "lib/mysql2/nested_hash_bind/version"

Gem::Specification.new do |spec|
  spec.name = "mysql2-nested_hash_bind"
  spec.version = Mysql2::NestedHashBind::VERSION
  spec.authors = ["sue445"]
  spec.email = ["sue445@sue445.net"]

  spec.summary = "mysql2 and mysql2-cs-bind extension to bind response to nested Hash"
  spec.description = "mysql2 and mysql2-cs-bind extension to bind response to nested Hash"
  spec.homepage = "https://github.com/sue445/mysql2-nested_hash_bind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mysql2"
  spec.add_dependency "mysql2-cs-bind"

  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "yard"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
