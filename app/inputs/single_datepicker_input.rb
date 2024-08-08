class SingleDatepickerInput < SimpleForm::Inputs::StringInput
  # This method only create a basic input without reading any value from object
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    merged_input_options[:class] << 'set-datepicker mask-date string'
    merged_input_options[:value] = l object[attribute_name] if object[attribute_name].present?

    @builder.text_field(attribute_name, merged_input_options)
  end
end