Gem::Specification.new do |s|
  s.name        = "asset_host_selection"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Chapweske", "Morten Primdahl"]
  s.email       = ["eac@zendesk.com"]
  s.homepage    = "http://github.com/zendesk/asset_host_selection"
  s.summary     = "Multiple asset host selection for ActionController"
  s.description = "Adds support for serving assets from multiple providers."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency("rake")
  s.add_development_dependency("bundler")
  s.add_development_dependency("rack")

  s.files        = Dir.glob("lib/**/*")
  s.test_files   = Dir.glob("test/**/*")
  s.require_path = 'lib'
end
