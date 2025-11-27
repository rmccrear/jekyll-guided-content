require 'jekyll'

module Jekyll
  # Utility bar tag - outputs a placeholder that will be replaced by the hook
  # This tag just outputs a marker that the hook will find and replace
  class UtilityBarTag < Liquid::Tag
    def render(context)
      # Output a unique marker that the hook can find and replace
      '<!-- UTILITY_BAR_PLACEHOLDER -->'
    end
  end
end

Liquid::Template.register_tag('utility_bar', Jekyll::UtilityBarTag)

