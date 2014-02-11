module Jekyll
  module Tags
    class Try < Liquid::Block

      def initialize(tag_name, text, tokens)
        super
        @text = text.strip
      end


      def render(context)
        output = "Try it out&nbsp;<a href=\"#{super}\" target=\"_blank\"><img style=\"display:inherit;\" src=\"/attachment_files/navigation/tryit.jpg\" alt=\"Try it out\"></a>"
      end
    end
  end
end

Liquid::Template.register_tag('try', Jekyll::Tags::Try)

