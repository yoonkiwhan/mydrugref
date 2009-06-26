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
    @drug1s = @post.drug_refs.find_all {|d| d.label == 'int_drug1'}
    @drug1s = @drug1s.map {|d| {:code => d.code, :atc => d.tc_atc_number}}
    @drug2s = @post.drug_refs.find_all {|d| d.label == 'int_drug2'}
    @drug2s = @drug2s.map {|d| {:code => d.code, :atc => d.tc_atc_number}}
  end
  
 
  private
    def model_name; 'Interaction'; end


end
