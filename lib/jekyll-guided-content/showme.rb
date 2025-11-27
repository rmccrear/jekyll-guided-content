require 'jekyll'

module Jekyll
  # ShowMe tag that leverages Pandoc's ::: details syntax.
  # Outputs markdown that Pandoc will process into native <details> elements.
  #
  # Usage:
  #   {% showme "Code Example" %}
  #   ```ruby
  #   def hello
  #     puts "world"
  #   end
  #   ```
  #   {% endshowme %}
  #
  #   {% showme %}
  #   Content without custom summary
  #   {% endshowme %}
  class ShowMeTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @summary = parse_summary(markup)
    end

    def render(context)
      content = super  # Get the block content (raw markdown)
      
      # Determine the summary text
      summary_text = @summary || "Show Me:"
      
      # Output native HTML <details> tag with markdown="block" attribute.
      # This tells Kramdown to process the content inside the HTML tag as markdown.
      <<~HTML
        <details class="showme" markdown="block">
          <summary>#{summary_text}</summary>
          #{content}
        </details>
      HTML
    end

    private

    def parse_summary(markup)
      return nil if markup.nil? || markup.strip.empty?
      
      # Remove quotes from summary if present
      summary = markup.strip.gsub(/^["']|["']$/, '')
      summary.empty? ? nil : summary
    end
  end
end

Liquid::Template.register_tag('showme', Jekyll::ShowMeTag)

