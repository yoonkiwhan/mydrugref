module PostsHelper

 def add_drug_button(name, form_builder)
   button_to_function name, :style => 'standard' do |page|
     form_builder.fields_for :drug_refs, DrugRef.new, :child_index => 'NEW_RECORD' do |f|
       html = render(:partial => 'drug_ref', :locals => { :dr => f, :unique_num => 'NUMHERE' })
       page << "$('drug_refs').insert({ bottom: '#{escape_javascript(html)}'.replace(/(NEW_RECORD)|(NUMHERE)/g, new Date().getTime()) });"
     end
   end
 end

 def remove_drug_ref_link(form_builder)
     if form_builder.object.new_record?
       # If the drugref is a new record, we can just remove the div from the dom
       link_to_function("Remove Drug", "$(this).up('.drugref').remove();")
     else
       # However if it's a "real" record it has to be deleted from the database,
       # for this reason the new fields_for, accept_nested_attributes helpers give us _delete,
       # a virtual attribute that tells rails to delete the child record.
       form_builder.hidden_field(:_delete) +
       link_to_function("Remove Drug", "$(this).up('.drugref').hide(); $(this).previous().value = '1'")
     end
   end

end
