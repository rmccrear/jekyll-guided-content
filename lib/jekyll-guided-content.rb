# frozen_string_literal: true

require "jekyll"
require "liquid"

module Jekyll
  module GuidedContent
    VERSION = "0.1.0"
  end
end

# ---------------------------------------------------------
# IMMEDIATE REGISTRATION
# ---------------------------------------------------------
# We use require_relative to force Ruby to load these files
# synchronously right now. This guarantees that all tags,
# converters, and hooks are registered before Jekyll begins
# the 'process' or 'render' stages.
# ---------------------------------------------------------

# 1. Tags (Must register before Liquid parsing begins)
require_relative "jekyll-guided-content/showme"
require_relative "jekyll-guided-content/level"
require_relative "jekyll-guided-content/utility_bar_tag"

# 2. Commands (Must be required for Jekyll CLI to recognize them)
require_relative "jekyll-guided-content/commands/init_course"
require_relative "jekyll-guided-content/commands/scaffold_lesson"
require_relative "jekyll-guided-content/commands/create_sample_lesson"

# ---------------------------------------------------------
# ENSURE EARLY LOADING VIA BUNDLER
# ---------------------------------------------------------
# If Bundler is available and we're in a :jekyll_plugins group,
# ensure the group is required. This guarantees tags are
# registered before Jekyll starts parsing.
# ---------------------------------------------------------
if defined?(Bundler)
  begin
    Bundler.require(:jekyll_plugins)
  rescue Bundler::GemfileNotFound, Bundler::GitError
    # Not in a Bundler context, or gemfile issues
    # Tags are already registered above, so this is fine
  end
end



