class TreatmentsController < PostsController

  def index
    super
    @sort_by = case params[:sort_by]
                 when "Condition" then "name"
                 when "Author" then "created_by"
                 else "created_at"
               end

    @order = case params[:order]
               when nil then "DESC"
               else params[:order]
             end

    @posts = Treatment.paginate :page => params[:page], :order => "#{@sort_by} #{@order}", :per_page => 20

    @header_hash = {"Condition" => "sortable" , "Drug of Choice" => "unsortable", "Category" => "unsortable", 
                    "Author" => "sortable", "Created" => "sortable", "Comments" => "unsortable" }
    if params[:sort_by]
      @header_hash[params[:sort_by]] = @order
    else
      @header_hash["Created"] = "DESC"
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
