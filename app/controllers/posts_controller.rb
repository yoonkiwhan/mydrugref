class PostsController < ApplicationController
  
  
  before_filter :find_post, :only => [ :show, :download, :edit, :update, :destroy ]
  before_filter :check_permissions, :only => [ :update, :destroy ]
  
  def home
    flash.keep
    redirect_to 'posts/news'
  end
  
  def index
    @page_title = post_type.pluralize
    @post = model.new
    @posts = model.find :all
  end
  
  def new
    @page_title = "New #{post_type}"
    @edit_on = true
    @post = model.new
  end
  
  def add_price
    @post = Post.find(params[:id])
  end
 
  def create
    @post = model.new params[:post]
    @post.creator = current_user
    @post.updated_by = @post.created_by
    
    if @post.save 
      flash[:notice] = 'Post successfully created.'
      redirect_to :action => 'index'
    else
      @page_title = "New #{post_type}"
      @edit_on = true
      render :action => 'new'
    end
  end

  def show
     
  end

  def download
    filename = @post.attachment_filename.split(/\\/).last
    send_data @post.attachment.content, :filename => filename, :type => @post.attachment_content_type, :disposition => 'attachment'
  end
  
  def edit
    @edit_on = true
    render :action => 'show'
  end
  
  def update
    if @post.update_attributes params[:post].merge(:updated_by => current_user)
      flash[:notice] = 'Your changes were saved.'
      redirect_to :action => 'show'
    else
      @edit_on = true
      render :action => 'show'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "The post was deleted."
    redirect_to :action => 'index'
  end
 
  def news
    @page_title = "Recent Updates"
    @warnings_today = Warning.today
    @interactions_today = Interaction.today
    @treatments_today = Treatment.today
    @bulletins_today = Bulletin.today
    @post_pages, @posts = paginate :posts, :per_page => 5
    @latest_w = Warning.latest
    @latest_i = Interaction.latest
    @latest_t = Treatment.latest
    @latest_b = Bulletin.latest
  end
  
   def cheese
    @page_title = "Search Results"
    @type_options = params[:type_options]
    @date_options = params[:date_options]
    @author_options = params[:author_options]
    
    # THIS IS REALLY TERRIBLE UNDER HERE
              if @date_options == "1"
                @date_options = Time.now.at_beginning_of_year
              elsif @date_options == "2"
                @date_options = Time.now.at_beginning_of_month
              elsif @date_options == "3"
                @date_options = Time.now.at_beginning_of_week
              elsif @date_options == "4"
                @date_options = Time.today
              end
              # FIX IT EVENTUALLY OK???
    if @author_options == "trust"
      @author_options = @current_user.friends
    end
    
    @conditions = ["type = ? and created_at between ? AND ?", @type_options, @date_options, Time.now]
    @query = params[:query]
   
    if @type_options == "all" and @date_options == "all"
    @total, @cheese = Post.full_text_search(@query, { :page => (params[:page]||1)})       
   
    elsif @type_options == "all" and @date_options == "all" and @author_options != "all"
    @total, @cheese = Post.full_text_search(@query, { :page => (params[:page]||1)},
                                                      { :conditions => ["created_by = ?", @author_options]})
    
   
    elsif @type_options == "all" and @date_options != "all"
    @total, @cheese = Post.full_text_search(@query, { :page => (params[:page]||1)},
                                                      { :conditions => ["created_at between ? AND ?", @date_options, Time.now]})
    
    elsif @type_options != "all" and @date_options == "all"
    @total, @cheese = Post.full_text_search(@query, { :page => (params[:page]||1)},
                                                      { :conditions => ["type = ?", @type_options]})   
       
    else
    @total, @cheese = Post.full_text_search(@query,  {:page => (params[:page]||1)},
                                                        {:conditions => @conditions})
    end
    @pages = pages_for(@total)
    render :partial => "posts/search", :layout => true
  end
  
  def advanced_search
    @page_title = 'Advanced Search'
  end
  
  def auto_complete_for_post_name
    value = params[:post][:name]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:name].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_drug2
    value = params[:post][:drug2]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:drug2].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_fldrug1
    value = params[:post][:fldrug1]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:fldrug1].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_fldrug3
    value = params[:post][:fldrug3]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:fldrug3].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_sldrug1
    value = params[:post][:sldrug1]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:sldrug1].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_sldrug2
    value = params[:post][:sldrug2]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:sldrug2].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_sldrug3
    value = params[:post][:sldrug3]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:sldrug3].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_pregdrug1
    value = params[:post][:pregdrug1]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:pregdrug1].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_pregdrug2
    value = params[:post][:pregdrug2]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:pregdrug2].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def auto_complete_for_post_pregdrug3
    value = params[:post][:pregdrug3]
    @drugs = Drug.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:post][:pregdrug3].downcase + '%' ],
      :order => 'name ASC',
      :limit => 20)
    render :partial => 'drugs'
  end
  
  def popup
    render :layout => false
  end
  
  private
  
    # The name of the model associated with the controller. Expected to be overridden.
    def model_name; 'Post'; end

    # The 'human name' of the model, if different from the actual model name.
    def post_type; model_name; end
    helper_method :post_type

    # The model class associated with the controller.
    def model; eval model_name; end
  
    def find_post
      @post = model.find params[:id]
    end
    
    # Before filter to bail unless the user has permission to edit the post.
    def check_permissions
      unless can_edit? @post
        flash.now[:warning] = "You can't edit that post."
        redirect_to :action => 'show'
        return false
      end
    end
  
end
