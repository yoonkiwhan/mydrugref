require File.dirname(__FILE__) + '/../test_helper'
require 'treatments_controller'

# Re-raise errors caught by the controller.
class TreatmentsController; def rescue_action(e) raise e end; end

class TreatmentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TreatmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
