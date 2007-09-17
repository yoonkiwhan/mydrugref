require File.dirname(__FILE__) + '/../test_helper'
require 'cd_drug_product_controller'

# Re-raise errors caught by the controller.
class CdDrugProductController; def rescue_action(e) raise e end; end

class CdDrugProductControllerTest < Test::Unit::TestCase
  def setup
    @controller = CdDrugProductController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
