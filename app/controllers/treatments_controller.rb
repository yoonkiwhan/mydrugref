class TreatmentsController < PostsController

  def index
    super
    @sort_by = params[:sort_by]
       if @sort_by == "condition"
	  @posts = Treatment.paginate :page => params[:page], :order => 'name', :per_page => 20
       elsif @sort_by == "author"
	  @posts = Treatment.paginate :page => params[:page], :order => 'created_by', :per_page => 20
       else
 	  @posts = Treatment.paginate :page => params[:page], :order => 'created_at desc', :per_page => 20
       end
  end
  
  def show
    super
    @flds = @post.drug_refs.find_all { |d| d.label.include?('FLD')}
    @slds = @post.drug_refs.find_all { |d| d.label.include?('SLD')}
    @pregs = @post.drug_refs.find_all { |d| d.label.include?('Preg')}
  end
  
  def remove_tag
    @post = Treatment.find(params[:id])
    @post.tags.delete(Tag.find(params[:which_tag]))
    if @post.save
      flash[:notice] = 'Tag has been removed.'
    end
    redirect_to :action => 'show', :id => @post  
  end
  

  private
    def model_name; 'Treatment'; end
    


end
