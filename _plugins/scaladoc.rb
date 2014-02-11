module Jekyll
  class Scaladoc < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @class_name = text.strip
    end

    def render(context)
      create_link(context, super)
    end

    def create_link(context, content)
      current_release = DocUtils.get_current_version(context)

      base_scaladoc_url = context.registers[:site].config["base_scaladoc_url"] || 
                         "http://www.gigaspaces.com/docs/scaladocs%{version}/#%{fqcn}"

      base_scaladoc_url % {:version => current_release, :fqcn => @class_name}
    end
  end
end

Liquid::Template.register_tag('scaladoc', Jekyll::Scaladoc)