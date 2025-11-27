require 'jekyll'

module Jekyll
  # Simple step tag that wraps content in a div with step styling.
  # Works with Pandoc markdown converter.
  #
  # Usage:
  #   {% level subtitle="Planning" %}
  #   Content here...
  #   {% endlevel %}
  #
  # The subtitle will be used to generate an anchor ID for deep linking.
  # For example, "Setup and Configuration" becomes id="setup-and-configuration"
  # Each level is automatically numbered per page, starting at 1.
  class LevelTag < Liquid::Block
    # Class variable to track step numbers per page
    @@step_numbers = {}
    
    # Hook to reset step counter when a page starts rendering
    Jekyll::Hooks.register :pages, :pre_render do |page|
      # Reset step counter for this page
      if page.is_a?(Jekyll::Page) && (page.ext == '.md' || page.ext == '.markdown')
        page_path = page.path || page.name || "unknown"
        @@step_numbers[page_path] = 0
      end
    end

    def initialize(tag_name, markup, tokens)
      super
      @subtitle = parse_subtitle(markup)
    end

    def render(context)
      content = super  # Get the block content
      
      # Get the site and markdown converter (will use Pandoc)
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)
      
      # Process the content as markdown (Pandoc will handle it)
      # Strip the input content to remove leading/trailing whitespace from the liquid block
      # This prevents the first line from being treated as a code block if it has indentation
      # Also strip the output HTML to ensure clean nesting
      html_content = converter.convert(content.strip).strip
      
      # Get current page path for tracking step numbers per page
      page_path = begin
        page = context.registers[:page]
        if page.respond_to?(:path)
          page.path
        elsif page.respond_to?(:name)
          page.name
        else
          nil
        end
      rescue
        nil
      end
      
      # Use page path as key, or fallback to a content-based identifier
      # The key needs to be stable across all level tags on the same page
      page_key = page_path || begin
        # Try to get page from site
        site = context.registers[:site]
        if site && site.pages.any?
          # Use first page as fallback (not ideal, but better than nothing)
          site.pages.first&.path || "default"
        else
          "default"
        end
      end
      
      # Initialize counter for this page if it doesn't exist
      @@step_numbers[page_key] ||= 0
      
      # Increment step number for this page
      @@step_numbers[page_key] += 1
      step_number = @@step_numbers[page_key]
      
      # Build the step header if subtitle exists
      # Uses Bulma's .level class for horizontal layout, keeps .step-header for customization
      # Includes an anchor ID for deep linking based on the subtitle
      # Adds data-step-number attribute for TOC numbering
      header_html = if @subtitle
        anchor_id = slugify(@subtitle)
        "<h2 class=\"step-header level\" id=\"#{anchor_id}\" data-step-number=\"#{step_number}\">#{@subtitle}</h2>"
      else
        nil
      end
      
      # Use Array#join to build the HTML sandwich.
      # This ensures wrapper tags are flush-left (0 indentation) to avoid
      # triggering Markdown code blocks, while keeping the inner content untouched.
      [
        "<div class=\"step box step-#{step_number}\">",
        header_html,
        "<div class=\"content\">",
        html_content,
        "</div>",
        "</div>"
      ].compact.join("\n")
    end

    private

    def parse_subtitle(markup)
      # Parse subtitle="value" or subtitle='value'
      match = markup.strip.match(/subtitle=["']([^"']+)["']/i)
      match ? match[1] : nil
    end

    def slugify(text)
      # Convert to lowercase
      slug = text.downcase
      
      # Replace spaces and underscores with hyphens
      slug = slug.gsub(/[\s_]+/, '-')
      
      # Remove special characters, keep only alphanumeric and hyphens
      slug = slug.gsub(/[^a-z0-9\-]/, '')
      
      # Collapse multiple consecutive hyphens into one
      slug = slug.gsub(/-+/, '-')
      
      # Remove leading and trailing hyphens
      slug = slug.gsub(/^-+|-+$/, '')
      
      # Ensure we have a valid ID (fallback if slug is empty)
      slug.empty? ? 'step' : slug
    end
  end
end

Liquid::Template.register_tag('level', Jekyll::LevelTag)

# Hook to reset step counter when a page starts rendering
Jekyll::Hooks.register :pages, :pre_render do |page|
  # Reset step counter for this page
  if page.is_a?(Jekyll::Page) && (page.ext == '.md' || page.ext == '.markdown')
    page_path = page.path || page.name || "unknown"
    Jekyll::LevelTag.class_variable_set(:@@step_numbers, {}) if page_path
    # Initialize counter for this page to 0
    step_numbers = Jekyll::LevelTag.class_variable_get(:@@step_numbers)
    step_numbers[page_path] = 0
  end
end

