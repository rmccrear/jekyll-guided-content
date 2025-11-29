# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jekyll-guided-content"
  spec.version       = "0.1.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["your.email@example.com"]

  spec.summary       = "Jekyll theme for course and lesson content with focus mode"
  spec.description   = "A Jekyll theme providing course structure, lesson pages, focus mode navigation, and synchronized TOC"
  spec.homepage      = "https://github.com/username/jekyll-guided-content"
  spec.license       = "MIT"

  spec.metadata      = {
    "source_code_uri" => "https://github.com/username/jekyll-guided-content",
    "github_repo" => "https://github.com/username/jekyll-guided-content"
  }

  # CRITICAL: Ensure 'files' includes everything in lib
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{lib,_layouts,_includes,assets}/**/*", "jekyll-guided-content.gemspec", "README.md", "QUICKSTART.md", "LESSON_PROMPT.md", "LICENSE", "CHANGELOG.md"]
  end
  
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.8", "< 5.0"
  spec.add_dependency "paru", ">= 0.3.0"
  spec.add_dependency "nokogiri", ">= 1.0"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end

