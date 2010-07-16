require 'rexml/document'

class GuidelinesController < PostsController
  layout "application", :except => [:condition, :consequence, :drug_search, :dx_search]

  def index
    super
    @grouped_posts = @posts.group_by {|g| g.uuid}
    @grouped_posts.each do |k, v|
      @grouped_posts[k] = v.sort_by {|g| g.id}
    end
  end
  
  def show
    parse_xml
  end
  
  def edit
    super
    parse_xml
  end

  def update
    # When users 'update' their Guideline, they actually create a new Guideline with a new id, but the same uuid
    # as the original Guidline. This simulates 'versioning'.
    
    # Make a copy of the old guideline
    new_g = Guideline.new(@post.attributes)
    new_g.save
    @new_id = new_g.id
    
    # Rewrite new_g's uuid back to @post's because creating a Guideline generates a new uuid
    if new_g.update_attributes params[:post].merge(:uuid => @post.uuid)
      flash[:notice] = 'Your post has been updated.'
      respond_to do |format|
        format.js if request.xhr?
        format.html { redirect_to guideline_url(@new_id) }
      end
    else
      @edit_on = true
      render :action => 'edit'
    end
  end

  def get_dxcodes
    params[:dxcodes].nil? ? existing_atcs = [] : existing_atcs = params[:dxcodes]

    target_table = params[:in]
    value = ('%' + params[:dxtext] + '%').gsub(' ', '%')

    if target_table == "icd9"
      got = IcdNine.find(:all, :conditions => ['LOWER(description) LIKE ?', value.downcase], 
                           :select => 'code, description')
      target = "icd9"
    elsif target_table == "icd10"
      got = IcdTen.find(:all, :conditions => ['LOWER(description) LIKE ?', value.downcase], 
                           :select => 'code, description')
      target = "icd10"
    end

    @results = arrange(got, target, existing_atcs)

    render :partial => 'dxresults', :object => @results
  end

  def arrange(got, target, existing_atcs)
    return_array = []
    for result in got
      h = {:dx_code => target + ':' + result.code, :dx_desc => result.description, :added => existing_atcs.include?(result.code)}
      return_array << h
    end

    return return_array
  end



  private
    def model_name; 'Guideline' end

    def parse_xml
      begin
        xml_bod = REXML::Document.new @post.body
        raise REXML::ParseException, "Not XML" if xml_bod.root.nil?
      rescue REXML::ParseException => exc
        @invalid = true
        @message = exc
      else
        @page_title = xml_bod.root.attributes["title"] unless xml_bod.root.attributes["title"].nil?
        @evidence = xml_bod.root.attributes["evidence"]
        @significance = xml_bod.root.attributes["significance"]
        # parsing conditions into hashes
        @conditions = []
        xml_bod.elements.each("*/conditions/condition") { |c| @conditions << c.attributes }
        @consequences = []
        @uuid = @post.uuid
        begin
          xml_bod.root.elements["consequence"].elements.each { |w|
            hash = w.attributes
            hash['name'] = w.name
            hash['text'] = w.text
            @consequences << hash
          }
        rescue NoMethodError # Root has no elements
        end
      end
    end

end
