class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput

  def input(wrapper_options)
    label_method, value_method = detect_collection_methods

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)


    if merged_input_options[:select2_class].present? || merged_input_options[:select2_class].nil?
      merged_input_options[:class] << if merged_input_options[:select2_class].present?
                                        merged_input_options.delete(:select2_class)
                                      else
                                        'select2-default'
                                      end
    end

    @builder.collection_select(
      attribute_name, collection, value_method, label_method,
      input_options, merged_input_options
    )
  end
end