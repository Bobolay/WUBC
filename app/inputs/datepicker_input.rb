class DatepickerInput < SimpleForm::Inputs::Base
  def input
    icon_source = File.read(Rails.root.join("app/assets/images/icons/calendar.svg"))
    @builder.text_field(attribute_name, input_html_options) + \
    "<label class='icon icon-calendar'>#{icon_source}</label>".html_safe + \
    @builder.hidden_field(attribute_name, { :class => attribute_name.to_s + "-alt"})
  end
end