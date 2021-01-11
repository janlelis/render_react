# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/render_react/version"

Gem::Specification.new do |gem|
  gem.name          = "render_react"
  gem.version       = RenderReact::VERSION
  gem.summary       = "Lo-fi way of rendering React components"
  gem.description   = "Lo-fi way of rendering React components."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["hi@ruby.consulting"]
  gem.homepage      = "https://github.com/janlelis/render_react"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^(pkg|spec)/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.0"
  gem.add_dependency "execjs", "~> 2.7"
end
