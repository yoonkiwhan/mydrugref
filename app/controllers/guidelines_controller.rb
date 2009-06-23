class GuidelinesController < PostsController

  def index
    super
    @grouped_posts = @posts.group_by {|g| g.uuid}
    @grouped_posts.each do |k, v|
      @grouped_posts[k] = v.sort_by {|g| g.id}
    end
  end
  
  def show
    super
    xml_bod = REXML::Document.new @post.body
    @page_title = xml_bod.root.attributes["title"] unless xml_bod.root.attributes["title"].nil?
    @evidence = xml_bod.root.attributes["evidence"]
    @significance = xml_bod.root.attributes["significance"]
    # parsing conditions into hashes
    @conditions = []
    xml_bod.elements.each("*/conditions/condition") { |c| @conditions << c.attributes }
    @consequences = []
    xml_bod.root.elements["consequence"].elements.each { |w|
      hash = w.attributes
      hash['name'] = w.name
      hash['text'] = w.text 
      @consequences << hash
    }
  end
  
  def update
    # When users 'update' their Guideline, they actually create a new Guideline with a new id, but the same uuid
    # as the original Guidline. This simulates 'versioning'.
    
    # Make a copy of the old guideline
    new_g = Guideline.new(@post.attributes)
    new_g.save
    
    # Rewrite new_g's uuid back to @post's because creating a Guideline generates a new uuid
    if new_g.update_attributes params[:post].merge(:updated_by => current_user, :uuid => @post.uuid)
      flash[:notice] = 'Your post has been updated.'
      redirect_to guideline_url(new_g.id)
    else
      @edit_on = true
      render :action => 'edit'
    end
    
  end

  private
    def model_name; 'Guideline'; end

end