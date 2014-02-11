#<div style="width:425px;text-align:left"><a style="font:14px Helvetica,Arial,Sans-serif;color: #0000CC;display:block;margin:12px 0 3px 0;text-decoration:underline;" href="http://www.slideboom.com/presentations/201781/PowerPoint-Presentation" title="PowerPoint Presentation">PowerPoint Presentation</a><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="425" height="370" id="onlinePlayer"><param name="movie" value="http://www.slideboom.com/player/player.swf?id_resource=201781"><param name="allowScriptAccess" value="always"><param name="quality" value="high"><param name="bgcolor" value="#ffffff"><param name="allowFullScreen" value="true"><param name="flashVars" value=""><embed src="http://www.slideboom.com/player/player.swf?id_resource=201781" width="425" height="370" name="onlinePlayer" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" allowscriptaccess="always" quality="high" bgcolor="#ffffff" allowfullscreen="true" flashvars=""></object><div style="font-size:11px;font-family:tahoma,arial;height:26px;padding-top:2px;">View <a href="http://www.slideboom.com" style="color: #0000CC;">more presentations</a> or <a href="http://www.slideboom.com/upload" style="color: #0000CC;">Upload</a> your own.</div></div>

module Jekyll
  class SlideboomrackspacewebinarTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      output = <<-output
<div style="width:425px;text-align:left">
  <a style="font:14px Helvetica,Arial,Sans-serif;color: #0000CC;display:block;margin:12px 0 3px 0;text-decoration:underline;" href="http://www.slideboom.com/presentations/201781/PowerPoint-Presentation" title="PowerPoint Presentation">
    PowerPoint Presentation
  </a>
  <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="425" height="370" id="onlinePlayer">
    <param name="movie" value="http://www.slideboom.com/player/player.swf?id_resource=201781">
    <param name="allowScriptAccess" value="always">
    <param name="quality" value="high">
    <param name="bgcolor" value="#ffffff">
    <param name="allowFullScreen" value="true">
    <param name="flashVars" value="">
    <embed src="http://www.slideboom.com/player/player.swf?id_resource=201781" width="425" height="370" name="onlinePlayer" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" allowscriptaccess="always" quality="high" bgcolor="#ffffff" allowfullscreen="true" flashvars="">
  </object>
  <div style="font-size:11px;font-family:tahoma,arial;height:26px;padding-top:2px;">
    View <a href="http://www.slideboom.com" style="color: #0000CC;">more presentations</a> or <a href="http://www.slideboom.com/upload" style="color: #0000CC;">Upload</a> your own.
  </div>
</div>
output
    end
  end
end

Liquid::Template.register_tag('slideboomrackspacewebinar', Jekyll::SlideboomrackspacewebinarTag)
