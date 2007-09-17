class LabelingFormBuilder < ActionView::Helpers::FormBuilder

  # Overrides default field helpers, adding support for automatic <label> tags with
  # inline validation messages.
  (%w(text_field password_field text_area date_select file_field)).each do |selector|
    src = <<-end_src
      def #{selector}(method, options = {})
        text = options.delete(:label) || method.to_s.humanize
        errors = @object.errors.on(method.to_s)
        errors = errors.is_a?(Array) ? errors.first : errors.to_s
        html = '<label for="' + @object_name.to_s + '_' + method.to_s + '">'
        html << text
        html << ' <span class="error">' + errors + '</span>' unless errors.blank?
        html << '</label> '
        #{selector=='date_select' ? "html << '<span id=\"' + @object_name.to_s + '_' + method.to_s + '\"></span>'" : ""}
        html << super
        html
      end
    end_src
    class_eval src, __FILE__, __LINE__
  end

end
