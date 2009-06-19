class InteractionsController < PostsController
  
  def index
    super
    @sort_by = params[:sort_by]
       if @sort_by == "effect"
	  @posts = Interaction.paginate :page => params[:page], :order => 'effect', :per_page => 25
       elsif @sort_by == "author"
	  @posts = Interaction.paginate :page => params[:page], :order => 'created_by', :per_page => 25
       else
	  @posts = Interaction.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 25
       end
  end
  
  def show
    super
    for dr in @post.drug_refs
      if dr.label == 'int_drug1'
        c = dr.code
        if c.nil?
          @drug1 = dr.tc_atc_number
          @atc1 = dr.tc_atc_number
        else
          @drug1 = c.tc_atc
          @atc1 = c.tc_atc_number
        end
      else
        c = dr.code
        if c.nil?
          @drug2 = dr.tc_atc_number
          @atc2 = dr.tc_atc_number
        else
          @drug2 = c.tc_atc
          @atc2 = c.tc_atc_number
        end
      end
    end
  end
  
 
  private
    def model_name; 'Interaction'; end


end
