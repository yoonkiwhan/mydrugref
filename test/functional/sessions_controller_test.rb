require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_login
    deb = User.find(3)
    post :create, :session => {:password => 'cheese', :email => 'dont_mugyourself@hotmail.com'}
    assert_equal deb.id, session[:user_id]
  end
  
end
