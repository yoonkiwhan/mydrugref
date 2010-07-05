class WarningsController < PostsController

  def index
    super
    @sort_by = case params[:sort_by]
                 when "Created" then "created_at"
                 when "Author" then "created_by"
                 else "cd_therapeutic_class.tc_atc"
               end

    @order = case params[:order]
               when nil then "ASC"
               else params[:order]
             end

    if @sort_by == "cd_therapeutic_class.tc_atc"
      @posts = Warning.paginate :page => params[:page], :include => :codes,
                                :order => "cd_therapeutic_class.tc_atc #{@order}", :per_page => 20
    else
      @posts = Warning.paginate :page => params[:page], :order => "#{@sort_by} #{@order}", :per_page => 20
    end

    @header_hash = {"Drug" => "sortable" , "Warning" => "unsortable",
                    "Author" => "sortable", "Created" => "sortable", "Comments" => "unsortable" }
    if params[:sort_by]
      @header_hash[params[:sort_by]] = @order
    else
      @header_hash["Drug"] = "ASC"
    end

  end
  
  def edit
    @edit_on = true
    @page_title = 'Edit Warning'
  end
  
  private
    def model_name; 'Warning'; end
    


end
