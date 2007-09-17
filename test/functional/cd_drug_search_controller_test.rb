require File.dirname(__FILE__) + '/../test_helper'
require 'cd_drug_search_controller'

# Re-raise errors caught by the controller.
class CdDrugSearchController; def rescue_action(e) raise e end; end

class CdDrugSearchControllerTest < Test::Unit::TestCase
  def setup
    @controller = CdDrugSearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
