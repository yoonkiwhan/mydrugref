# based on acts_as_authenticated (http://svn.techno-weenie.net/projects/plugins/acts_as_authenticated)
module Authentication
  protected

    def logged_in?
      return false unless session[:user_id]
      begin
        @current_user ||= User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        reset_session
      end
    end
    
    def current_user
      @current_user if logged_in?
    end
    
    def require_login
      username, passwd = get_auth_data
      self.current_user ||= User.authenticate(username, passwd) || :false if username && passwd
      return true if logged_in?
      respond_to do |format|
        format.html do
          session[:return_to] = request.request_uri
          redirect_to new_session_url
        end
        format.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Could't authenticate you", :status => '401 Unauthorized'
        end
      end
      false
    end
    
    def access_denied
      redirect_to new_session_url
    end  
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?
    end

  private

    def get_auth_data
      user, pass = nil, nil
      if request.env.has_key? 'X-HTTP_AUTHORIZATION' 
        authdata = request.env['X-HTTP_AUTHORIZATION'].to_s.split 
      elsif request.env.has_key? 'HTTP_AUTHORIZATION' 
        authdata = request.env['HTTP_AUTHORIZATION'].to_s.split  
      end 
      if authdata && authdata[0] == 'Basic' 
        user, pass = Base64.decode64(authdata[1]).split(':')[0..1] 
      end 
      return [user, pass] 
    end

end
