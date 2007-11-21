class UsersController < ApplicationController

#  before_filter :require_admin, :only => [ :new, :create ]
  before_filter :not_guest, :only => [ :new, :create ]
  before_filter :find_user, :only => [ :show, :edit, :update, :destroy ]
  before_filter :check_permissions, :only => [ :edit, :update, :destroy ]
  skip_before_filter :check_for_valid_user, :only => [ :edit, :update ]
  filter_parameter_logging :password
  
  def index
    @page_title = "MyDrugRef Users"
    @users = User.find :all, :order => 'name'
    @user = User.new
  end
  
  def new
    @page_title = "New User"
    @user = User.new
    @edit_on = true
  end

  def create
    @hash = params[:user]
    @hash["added_by"] = @current_user.id
    user = @hash
    if @user = User.create(@hash)
      UserMailer.deliver_greeting(user)
      flash[:notice] = 'User was successfully saved. Login information sent.'
      @current_user.friends << @user
      @user.friends << @current_user
      redirect_to user_url(:id => @user)
    else
      render :action => 'index'
    end
  end

  def show
    @posts = Post.find_all_by_created_by(@user)
    @treatments = Treatment.find_all_by_created_by(@user)
    @comments = Comment.find_all_by_created_by(@user)
    @interactions = Interaction.find_all_by_created_by(@user)
    @warnings = Warning.find_all_by_created_by(@user)
    @bulletins = Bulletin.find_all_by_created_by(@user)
    @products = Product.find_all_by_created_by(@user)
    @prices = Price.find_all_by_created_by(@user)
    @friends = @user.friends
    @allusers = User.find(:all)
    if params[:format]=='jpg'
      if @user.picture
        send_data @user.picture.content, :filename => "#{@user.id}.jpg", :type => 'image/jpeg', :disposition => 'inline'
      else
        send_file RAILS_ROOT+'/public/images/default_user.jpg', :filename => "#{@user.id}.jpg", :type => 'image/jpeg', :disposition => 'inline'
      end
      return
    end
  end

  def edit
    @edit_on = true
    @posts = Post.find_all_by_created_by(@user)
    @treatments = Treatment.find_all_by_created_by(@user)
    @comments = Comment.find_all_by_created_by(@user)
    @interactions = Interaction.find_all_by_created_by(@user)
    @warnings = Warning.find_all_by_created_by(@user)
    @bulletins = Bulletin.find_all_by_created_by(@user)
    @products = Product.find_all_by_created_by(@user)
    @prices = Price.find_all_by_created_by(@user)
    @friends = @user.friends
    @allusers = User.find(:all)
    render :action => 'show'
  end
  
  def update
    success = @user.update_attributes params[:user]
    respond_to do |format|
      format.html {
        if success
          flash[:notice] = 'User was successfully updated.'
          redirect_to user_url
        else
          @edit_on = true
          render :action => 'show'
        end
        }
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "User deleted."
    redirect_to users_url
  end

  def search_by_u
    @page_title = "Search Results"
    @users = User.find :all, :order => 'name'
    @type_options = params[:type_options]
    @author_options = params[:author_options]
    
    @friend_ids = Array.new
    
    for pal in @current_user.friends
    @friend_ids << pal.id
    end
    
    @conditions = ["type = ? and created_by = ?", @type_options, @author_options]
    @query = params[:query]

      if @type_options == "all" and @author_options == "all"
      @total, @search_by_u = Post.full_text_search(@query, { :page => (params[:page]||1)})       
       
      elsif @type_options == "all" and @author_options != "all"
      @total, @search_by_u = Post.full_text_search(@query, { :page => (params[:page]||1)},
                                                           { :conditions => ["created_by = ?", @author_options]})
    
      elsif @type_options != "all" and @author_options == "all"
      @total, @search_by_u = Post.full_text_search(@query, { :page => (params[:page]||1)},
                                                           { :conditions => ["type = ?", @type_options]})   
       
      elsif @type_options == "all" and @author_options == "trusted"
      @search_by_u = Post.trust_search(@query, @friend_ids, { :page => (params[:page]||1)})
        
      elsif @type_options != "all" and @author_options == "trusted"
      @search_by_u = Post.trust_search(@query, @friend_ids, { :page => (params[:page]||1)},
                                            { :conditions => ["type = ?", @type_options]})
      
      else
      @total, @search_by_u = Post.full_text_search(@query,  {:page => (params[:page]||1)},
                                                            {:conditions => @conditions})
      end
    @pages = pages_for(@total)
    render :partial => "search", :layout => true
   
  end

  private
  
    def post_type; "User"; end
    helper_method :post_type

    def find_user
      @user = User.find params[:id]
    end
    
    def check_permissions
      return false unless can_edit? @user
    end

end