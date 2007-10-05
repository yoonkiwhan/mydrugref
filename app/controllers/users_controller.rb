class UsersController < ApplicationController

  before_filter :require_admin, :only => [ :new, :create ]
  before_filter :find_user, :only => [ :show, :edit, :update, :destroy ]
  before_filter :check_permissions, :only => [ :edit, :update, :destroy ]
  skip_before_filter :check_for_valid_user, :only => [ :edit, :update ]
  filter_parameter_logging :password
  
  def index
    @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    if params[:id]
      @initial = params[:id]
      @users = User.find(:all,
                          :conditions => ["name like ?", @initial+'%'])
    end
    @page_title = "Users"
    @user = User.new
  end
  
  def new
    @page_title = "New User"
    @user = User.new
    @edit_on = true
  end

  def create
    if @user = User.create(params[:user])
      flash[:notice] = 'User was successfully saved.'
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
