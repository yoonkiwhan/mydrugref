require File.dirname(__FILE__) + '/../test_helper'
require 'cd_therapeutic_class_controller'

# Re-raise errors caught by the controller.
class CdTherapeuticClassController; def rescue_action(e) raise e end; end

class CdTherapeuticClassControllerTest < Test::Unit::TestCase
  def setup
    @controller = CdTherapeuticClassController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
