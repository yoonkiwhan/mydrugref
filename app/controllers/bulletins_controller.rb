class BulletinsController < PostsController

  def index
      super
      @posts = Bulletin.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 5
  end
  
  def show
    @page_title = @post.drugs[0].brand_name
    @code = @post.drugs[0].code
    @atc = @code.tc_atc_number
  end

  private
    def model_name; 'Bulletin'; end
    
end
