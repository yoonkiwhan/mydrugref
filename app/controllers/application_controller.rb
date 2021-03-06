# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_lofty_session_id'

  include Authentication
  before_filter :require_login, :except => [ :index, :show, :search, :news, :rss, :invoke, 
  :invoke_method_params, :invoke_submit, :api, :fetch, :best_value, :p_five, :update_table, :show_posts ]
  before_filter :check_for_valid_user
  
  def pages_for(size, options = {})
    default_options = {:per_page => 10}
    options = default_options.merge options
    pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
    return pages
  end

  private

    # Helper method to determine whether the current user can modify +record+
    def can_edit? record
      return true if current_user.admin? # admins can edit anything
      case record.class.to_s
        when 'User'
          record.id == current_user.id # regular users can't edit other users
        when 'Warning', 'Interaction', 'Treatment', 'Bulletin', 'ThreadedDiscussionPost', 'Price', 'Comment', 'Guideline'
          record.created_by == current_user.id # these posts can only be edited by their creators
        else true # everyone can edit anything else
      end
    end
    helper_method :can_edit?

    # Helper method to determine whether the current user is an administrator
    def admin?; current_user.admin?; end
    helper_method :admin?
    
    def not_guest
      if current_user.name == "Guest"
	 flash[:warning] = "Sorry, guests cannot do that."
         redirect_to Warnings_url
      end
    end

    # Before filter to limit certain actions to administrators
    def require_admin
      unless admin?
        flash[:warning] = "Sorry, only administrators can do that."
        redirect_to Warnings_url
      end
    end
    
    # Replacing spaces in a string with '%' so that, for example, a search for "tylenol 3" can return 
    # 'tylenol with codeine no. 3'
    def add_percents(s)
      s.insert(0, '%')
      s.insert(-1, '%')
      count = 0 
      while count < s.length
        if s[count, 1] == ' '
          s[count] = '%'
        end
        count += 1
      end
    end

    # Before filter that insists the current user model is valid -- generally
    # just used when the first user is created.
    # THIS IS THE PROBLEM.  In what way is the current model, with hashed password and salt, invalid?
    # when will it break?
    def check_for_valid_user
      if logged_in? and !current_user.valid?
        flash[:warning] = "Please create your administrator account"
        redirect_to edit_user_url(:id => current_user)
        return false
      end
    end

end
