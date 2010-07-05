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
    drs = @post.drug_refs
    @flds = drs.find_all { |d| d.label.include?('FLD')}
    @slds = drs.find_all { |d| d.label.include?('SLD')}
    @pregs = drs.find_all { |d| d.label.include?('Preg')}
    @dnus = drs.find_all { |d| d.label.include?('DNU')} 
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
