module Jekyll
  class CurrentNetUrl < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @class_name = text.strip
    end

    def get_current_version(context)
      versionDir = context.environments.first["page"]["url"].split("/")[1]
      if !versionDir.nil?
        if versionDir.start_with?("xap")          
          versionDir = versionDir.sub("net","")
          "/#{versionDir}net"
        else 
          context.registers[:site].config["latest_net_url"]
        end
      else
        context.registers[:site].config["latest_net_url"]
      end
    end 

    def render(context)
      get_current_version(context)
    end
  end
end

Liquid::Template.register_tag('currentneturl', Jekyll::CurrentNetUrl)