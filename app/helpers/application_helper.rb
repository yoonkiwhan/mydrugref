# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Returns the name of an icon (in public/images) for the given content type
  def icon_for content_type
    case content_type.to_s.strip
      when "image/jpeg"
        "JPG"
      when "application/vnd.ms-excel"
        "XLS"
      when "application/msword"
        "DOC"
      when "application/pdf"
        "PDF"
      else "Generic"
    end
  end

  # Returns a textual description of the content type
  def description_of content_type
    case content_type.to_s.strip
      when "image/jpeg"
        "JPEG graphic"
      when "application/vnd.ms-excel"
        "Excel worksheet"
      when "application/msword"
        "Word document"
      when "application/pdf"
        "PDF file"
      else ""
    end
  end
  
  # Returns the name of the site (for the title and h1 elements)
  def site_title
    ''
  end

  # If a page title isn't explicitly set with @page_title, it's inferred from the post or user title
  def page_title
    return @page_title if @page_title
    return @post.name if @post and !@post.new_record?
    return @user.name if @user and !@user.new_record?
    ''
  end

  # Returns a div for each key passed if there's a flash with that key
  def flash_div *keys
    keys.collect { |key| content_tag(:div, flash[key], :class => "flash #{key}") if flash[key] }.join
  end
  
  # Returns a div with the user's thumbnail and name
  def user_thumb user
    img = tag("img", :src => formatted_user_url(:id => user, :format => 'jpg'), :class => 'user_picture', :alt => user.name)
    img_link = link_to img, user_url(:id => user)
    text_link = link_to user.short_name, user_url(:id => user)
    content_tag :div, "#{img_link}<br/>#{text_link}", :class => 'user'
  end
  
  # Returns a div
  def clear_div
    '<div class="clear"></div>'
  end
  
  # if post is over 30 days old, produces this format: Thursday 25 May 2006 - 1:08 PM
  def nice_date(date)
    dt = DateTime.new(date.year, date.month, date.mday)
    diff = DateTime.now - dt
    if diff.to_i > 30
    h date.strftime("%A %d %B %Y - %H:%M %p")
    else
    return time_ago_in_words(date)+" ago"
    end
  end

  # Renders the form used for all post and user creating/editing.
  # Yields an instance of LabelingFormBuilder (see lib/labeling_form_helper.rb).
  def standard_form name, object, &block
    url  = { :action    => object.new_record? ? "index" : "show" }
    html = { :class     => "standard",
             :style     => (@edit_on ? '' : "display: none;"),
             :multipart => true }
    concat form_tag(url, html) + "<fieldset>", block.binding
    concat '<input name="_method" type="hidden" value="put" />', block.binding unless object.new_record?
    yield LabelingFormBuilder.new(name, object, self, {}, block)
    concat "</fieldset>", block.binding
  end

  #modifying standard_form so that tdpost create works
  def td_form name, object, &block
    url  = { :action    => "create" }
    html = { :class     => "standard",
             :style     => (@edit_on ? '' : "display: none;"),
             :multipart => true }
    concat form_tag(url, html) + "<fieldset>", block.binding
    concat '<input name="_method" type="hidden" value="put" />', block.binding unless object.new_record?
    yield LabelingFormBuilder.new(name, object, self, {}, block)
    concat "</fieldset>", block.binding
  end
  
  # Standard submit button and delete link for posts and users
  def standard_submit name=nil, object=nil
    name = post_type unless name
    object = @post unless object
    if name == "ThreadedDiscussionPost"
      submit_tag("Save Post") + (object.new_record? ? "" : (" or " + link_to("Delete", { :action => 'show' }, :method => :delete, :confirm => "Are you sure?", :class => "delete")))
    else
      submit_tag("Save #{name}") + (object.new_record? ? "" : (" or " + link_to("Delete", { :action => 'show' }, :method => :delete, :confirm => "Are you sure?", :class => "delete")))
    end
  end

end
