class WarningsController < PostsController

  def index
    super
       @sort_by = params[:sort_by]
       if @sort_by == "date"
	     @posts = Warning.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 20
       elsif @sort_by == "author"
	     @posts = Warning.paginate :page => params[:page], :order => 'created_by', :per_page => 20
       else
    	 @posts = Warning.paginate :page => params[:page], :include => :codes,
    	                           :order => 'cd_therapeutic_class.tc_atc', :per_page => 20
       end	
  end
  
  def edit
    @edit_on = true
    @page_title = 'Edit Warning'
  end
  
  private
    def model_name; 'Warning'; end
    


end
