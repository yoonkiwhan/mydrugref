class InteractionsController < PostsController
  
  def index
    super
    @sort_by = case params[:sort_by]
                 when "Effect" then "effect"
                 when "Author" then "created_by"
                 else "created_at"
               end

    @order = case params[:order]
               when nil then "DESC"
               else params[:order]
             end

    @posts = Treatment.paginate :page => params[:page], :order => "#{@sort_by} #{@order}", :per_page => 20

    @header_hash = {"Affecting Drug" => "unsortable" , "Effect" => "sortable", "Affected Drug" => "unsortable",
                    "Author" => "sortable", "Created" => "sortable", "Comments" => "unsortable" }
    if params[:sort_by]
      @header_hash[params[:sort_by]] = @order
    else
      @header_hash["Created"] = "DESC"
    end




    @sort_by = params[:sort_by]
       if @sort_by == "effect"
	  @posts = Interaction.paginate :page => params[:page], :order => 'effect', :per_page => 25
       elsif @sort_by == "author"
	  @posts = Interaction.paginate :page => params[:page], :order => 'created_by', :per_page => 25
       else
	  @posts = Interaction.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 25
       end
  end
  
  def show
    super
    @drug1s = @post.drug_refs.find_all {|d| d.label == 'int_drug1'}
    @drug1s = @drug1s.map {|d| {:code => d.code, :atc => d.tc_atc_number}}
    @drug2s = @post.drug_refs.find_all {|d| d.label == 'int_drug2'}
    @drug2s = @drug2s.map {|d| {:code => d.code, :atc => d.tc_atc_number}}
  end
  
 
  private
    def model_name; 'Interaction'; end


end
