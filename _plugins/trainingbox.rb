#<div class="training-box"><b>Wish to become a GigaSpaces professional and get training from our product experts? </b> <br>
#<a href="http://www.gigaspaces.com/content/gigaspaces-training" target="training">Click here</a> for details about our various training education programs.</div>

module Jekyll
  class TrainingboxTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      output = <<-output
<div class="well training-box">
<strong>Wish to become a GigaSpaces professional and get training from our product experts?</strong>
<br/>
<a href="http://www.gigaspaces.com/content/gigaspaces-training" target="training">Click here</a> for details about our various training education programs.
</div>
output
    end
  end
end

Liquid::Template.register_tag('trainingbox', Jekyll::TrainingboxTag)
