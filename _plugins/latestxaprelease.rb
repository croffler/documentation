require 'kramdown'
module Jekyll
  module Tags
    class LatestXapRelease < Liquid::Tag
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        context.registers[:site].config["latest_xap_release"]
      end
      
    end
  end
end

Liquid::Template.register_tag('latestxaprelease', Jekyll::Tags::LatestXapRelease)