module GuidelinesHelper

  def add_lab_button(name, form_builder)
     button_to_function name, :style => 'standard' do |page|
       form_builder.fields_for :labs, Lab.new, :child_index => 'NEW_RECORD' do |f|
         html = render(:partial => 'lab', :locals => { :lab_form => f })
         page << "$('labs').insert({ bottom: '#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()) });"
       end
     end
  end

  def remove_lab_link(form_builder)
    if form_builder.object.new_record?
      link_to_function("Remove Lab", "$(this).up('.lab').remove();");
    else
      form_builder.hidden_field(:_delete) +
      link_to_function("Remove Lab", "$(this).up('.lab').hide(); $(this).previous().value = '1'")
    end
  end

end
