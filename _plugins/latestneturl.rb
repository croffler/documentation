require 'kramdown'
module Jekyll
  module Tags
    class LatestNETUrl < Liquid::Tag
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        context.registers[:site].config["latest_net_url"]
      end
      
    end
  end
end

Liquid::Template.register_tag('latestneturl', Jekyll::Tags::LatestNETUrl)