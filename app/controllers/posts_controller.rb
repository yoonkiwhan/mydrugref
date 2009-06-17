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
    @post.drug_refs.build
    @posts = model.find :all
  end
  
  def new
    @page_title = "New #{post_type}"
    @edit_on = true
    @post = model.new
    @post.drug_refs.build
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
      redirect_to :action => 'show', :controller => @post.class.to_s + 's', :id => @post.id
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
    @page_title = "Last Ten Posts"
    @latest_p = Post.latest
  end
  
   def p_five
      @latest_p = Post.latest
      render :partial => 'p_five'
   end

   def search
    @page_title = "Search Results"
    @query = String.new(params[:query])
    add_percents(params[:query])
    if params[:type_options] == "All Posts"
      @results = Post.search(params[:query], params[:date_options], nil)
    else
      @results = Post.search(params[:query], params[:date_options], params[:type_options].chop)
    end
    render :partial => "posts/search", :layout => true
   end
  
  def get_results
    params[:atcs].nil? ? existing_atcs = [] : existing_atcs = params[:atcs]
    if params[:drugtext].length > 2
      value = ('%' + params[:drugtext] + '%').gsub(' ', '%')
      
      if params[:by] == 'brandname' # originally two functions (get_brandname_results and get_ingredient_results)
        objs = Drug.find(:all, :conditions => [ 'class_1=? AND LOWER(brand_name) LIKE ?', 'HUMAN', value.downcase], 
                         :select => 'brand_name, drug_code')
      else
        objs = ActiveIngredient.find(:all, :conditions => [ 'LOWER(ingredient) LIKE ?', value.downcase],
                                     :select => 'ingredient, drug_code')
        objs.delete_if{|a| a.code.nil?}
      end  
        
      atc_objs = objs.group_by { |ob| Code.find_by_drug_code(ob.drug_code, :select => 'tc_atc, tc_atc_number') }
      @results = []
      atc_objs.each do |code, obj_array|
        atc_code = code.tc_atc_number
        h = {:atc_code => atc_code, :atc_class => code.tc_atc, 
                     :added => existing_atcs.include?(atc_code),
                     :ais => ActiveIngredient.find(:all, 
                                                   :conditions => {:drug_code => obj_array[0].drug_code }, 
                                                   :select => 'ingredient') }
        if params[:by] == 'brandname'
          h[:brand_name] = obj_array[0].brand_name
        else
          h[:brand_name] = Drug.find_by_drug_code(obj_array[0].drug_code, :select => 'brand_name').brand_name
        end
        @results << h
      end
    else
      @results = []
    end
    if @results.empty?
      @results = params[:by]
    end
      render :partial => 'results', :object => @results 
  end
  
  def add_post_atc
    @post_atc = { :atc_code => params[:atc_code], :atc_class => params[:atc_class], :con_name => params[:con_name]}
    render :partial => 'post_atc', :object => @post_atc
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
      begin
        @post = model.find params[:id]
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempt to access invalid post #{params[:id]}")
        flash[:notice] = "Post does not exist"
        redirect_to("/#{post_type.pluralize}")
      end
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
