require File.dirname(__FILE__) + '/../test_helper'
require 'drugs_controller'

# Re-raise errors caught by the controller.
class DrugsController; def rescue_action(e) raise e end; end

class DrugsControllerTest < Test::Unit::TestCase
  def setup
    @controller = DrugsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
