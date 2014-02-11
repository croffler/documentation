module DocUtils

  def self.get_current_section(sectionPath)
    if !sectionPath.nil?
      if sectionPath.start_with?("xap")
        isDotNet = sectionPath.end_with?("net");
        isAdmin = sectionPath.end_with?("adm");
        isInstall = sectionPath.end_with?("inst");
        isDeploy = sectionPath.end_with?("dep");
        sectionPath = sectionPath.sub("xap","")
        sectionPath = sectionPath.sub("net","")
        sectionPath = sectionPath.sub("adm","")
        sectionPath = sectionPath.sub("inst","")
        sectionPath = sectionPath.sub("dep","")
        version = sectionPath.insert(sectionPath.length - 1, ".")
        if isDotNet 
          "XAP.NET " + version 
        elsif isAdmin
          return "XAP " + version + " Admin Guide"
        elsif isInstall
          return "XAP " + version + " Installation Guide"
        elsif isDeploy
          return "XAP " + version + " Deployment Guide"
        else 
          return "XAP " + version 
        end
      elsif sectionPath == "sbp" 
        "Solutions &amp; Best Practices"
      elsif sectionPath == "api_documentation"
        "API Documentation"
      elsif sectionPath == "early_access"
        "Early Access"
      elsif sectionPath == "product_overview"
        "Product Overview"
      elsif sectionPath == "tutorials"
        "Tutorials"
      elsif sectionPath == "howto"
        "How To"
      elsif sectionPath == "release_notes"
        "Release Notes"
      elsif sectionPath == "rta"
        "Realtime Analytics"
      elsif sectionPath == "faq"
        "FAQ"
      else
        ""
      end
    else
      ""
    end
  end 

  def self.get_current_version(context)
    versionDir = context.environments.first["page"]["url"].split("/")[1]
    if !versionDir.nil?
      if versionDir.start_with?("xap")
        versionDir = versionDir.sub("xap","")
        versionDir = versionDir.sub("net","")
        versionDir.insert(versionDir.length - 1, ".")
      else 
        context.registers[:site].config["latest_xap_release"]
      end
    else
      context.registers[:site].config["latest_xap_release"]
    end
  end 

end
