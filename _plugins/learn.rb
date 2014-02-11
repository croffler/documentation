module Jekyll
  module Tags
    class Learn < Liquid::Block
      
      def initialize(tag_name, text, tokens)
        super
        @text = text.strip
      end

      
      def render(context)
        output = "Learn more&nbsp;<a href=\"#{super}\" target=\"_blank\"><img style=\"display:inherit;\" src=\"/attachment_files/navigation/learn.jpeg\" alt=\"Learn more\"></a>"
      end
    end
  end
end

Liquid::Template.register_tag('learn', Jekyll::Tags::Learn)

