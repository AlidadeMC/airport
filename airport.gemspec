# frozen_string_literal: true

require_relative "lib/airport/version"

Gem::Specification.new do |spec|
  spec.name = "airport"
  spec.version = Airport::VERSION
  spec.authors = ["Marquis Kurt"]
  spec.email = ["software@marquiskurt.net"]

  spec.summary = "Manage plugins for PaperMC servers."
  spec.description = "Install and update plugins for PaperMC servers easily."
  spec.homepage = "https://github.com/alicerunsonfedora/airport"
  spec.required_ruby_version = ">= 3.1.0"

  spec.executables = ["airport"]
  spec.require_paths = ["lib"]

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
end
