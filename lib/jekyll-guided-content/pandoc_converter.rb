require 'jekyll'
require 'paru/pandoc'
require_relative 'details_transformer'

module Jekyll
  module Converters
    class Markdown
      # Custom Markdown converter using Pandoc with support for fenced divs syntax.
      #
      # This converter enables the use of ::: details syntax in Markdown files,
      # which gets converted to native HTML <details> elements with <summary> tags.
      #
      # Usage in markdown:
      #   ::: details
      #   <summary>Click to view</summary>
      #   Content here...
      #   :::
      #
      # Important: If you want to use Liquid tags ({% %}) inside the details/summary
      # blocks, wrap them in {% raw %} tags to prevent Liquid from processing them:
      #
      #   ::: details
      #   <summary>Example</summary>
      #   ```html
      #   {% raw %}
      #   {% if user.is_active %}
      #     <span>Active user</span>
      #   {% endif %}
      #   {% endraw %}
      #   ```
      #   :::
      #
      # This is necessary because Jekyll processes Liquid tags BEFORE the markdown
      # converter runs, so {% raw %} must be in your markdown source.
      class SummaryDetailsMdParser < Converter
        safe true
        priority :high

        def matches(ext)
          ext =~ /^\.md|markdown$/i
        end

        def output_ext(ext)
          ".html"
        end

        def convert(content)
          # 1. Convert Markdown to Generic HTML using Pandoc
          html_output = convert_with_pandoc(content)

          # 2. Convert Pandoc's code block classes to highlight.js format
          html_output = convert_code_classes(html_output)

          # 3. Post-Process HTML: Transform <div class="details"> into <details>
          Jekyll::Converters::DetailsTransformer.transform(html_output)
        end

        private

        # Converts markdown content to HTML using Pandoc with fenced_divs support.
        # This enables the ::: details syntax in markdown files.
        # Syntax highlighting is handled by highlight.js (see default.html layout).
        def convert_with_pandoc(content)
          pandoc = Paru::Pandoc.new do
            from "markdown+fenced_divs+backtick_code_blocks"
            to "html5"
          end

          pandoc.convert(content)
        end

        # Converts Pandoc's code block class format to highlight.js format.
        # Pandoc outputs: class="sourceCode ruby"
        # highlight.js expects: class="language-ruby"
        def convert_code_classes(html)
          # Ensure UTF-8 encoding
          html_utf8 = html.force_encoding('UTF-8')
          
          # Replace sourceCode <language> with language-<language> for highlight.js
          html_utf8.gsub(/class="sourceCode\s+(\w+)"/, 'class="language-\1"')
                   .gsub(/class="sourceCode\s+(\w+)\s+sourceCode"/, 'class="language-\1"')
        end
      end
    end
  end
end

