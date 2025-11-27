require 'nokogiri'

module Jekyll
  module Converters
    # HTML transformer that converts Pandoc's <div class="details"> elements
    # into native HTML <details> elements with proper <summary> handling.
    #
    # This module handles the post-processing step after Pandoc converts
    # markdown with fenced_divs (:::) syntax to HTML.
    module DetailsTransformer
      # Transforms HTML by converting all <div class="details"> elements
      # into semantic <details> elements with proper <summary> handling.
      #
      # @param html [String] HTML string containing div.details elements
      # @return [String] HTML string with <details> elements
      def self.transform(html)
        # Ensure UTF-8 encoding for Nokogiri
        html_utf8 = html.force_encoding('UTF-8')
        doc = Nokogiri::HTML::DocumentFragment.parse(html_utf8)

        doc.css('div.details').each do |div|
          convert_div_to_details(div, doc)
        end

        doc.to_html
      end

      private

      # Converts a single <div class="details"> element into a <details> element,
      # properly handling <summary> extraction and cleanup.
      #
      # @param div [Nokogiri::XML::Node] The div.details element to convert
      # @param doc [Nokogiri::HTML::DocumentFragment] The document fragment
      def self.convert_div_to_details(div, doc)
        # Create the new semantic <details> element
        details = Nokogiri::XML::Node.new('details', doc)
        # Add class to identify showme-generated details
        details['class'] = 'showme'

        # Search for the <summary> anywhere inside the div
        # Pandoc might output: <div class="details"><p><summary>...</summary></p></div>
        summary_node = div.at_css('summary')

        if summary_node
          extract_and_move_summary(summary_node, details)
        end

        # Move all remaining children of the div into the details element
        div.children.each do |child|
          details.add_child(child)
        end

        # Final Swap: Replace the old div with the new details element
        div.replace(details)
      end

      # Extracts a <summary> node from its current location and moves it to
      # the <details> element, cleaning up any empty parent <p> tags.
      #
      # Pandoc may wrap <summary> tags in <p> tags when processing fenced divs.
      # This method extracts the summary and removes any empty <p> wrappers.
      #
      # @param summary_node [Nokogiri::XML::Node] The summary element to extract
      # @param details [Nokogiri::XML::Node] The details element to move it to
      def self.extract_and_move_summary(summary_node, details)
        # 1. Remove the summary node from its current parent (to avoid duplication)
        parent_p = summary_node.parent
        summary_node.unlink

        # 2. Add the summary as the first child of <details>
        details.add_child(summary_node)

        # 3. Cleanup: If the summary was inside a <p> and that <p> is now empty, remove the <p>
        # This prevents empty <p></p> tags at the top of your details block.
        if parent_p.name == 'p' && parent_p.children.empty?
          parent_p.unlink
        end
      end
    end
  end
end

