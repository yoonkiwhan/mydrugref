class BulletinsController < PostsController

  def index
      super
      @posts = Bulletin.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 5
  end
  
  def show
    @page_title = @post.drug_refs[0].code.tc_atc
  end

  private
    def model_name; 'Bulletin'; end
    
end
