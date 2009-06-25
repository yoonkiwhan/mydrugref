require File.dirname(__FILE__) + '/../test_helper'
require 'backend_controller'

# Re-raise errors caught by the controller.
class BackendController; def rescue_action(e) raise e end; end

class BackendControllerApiTest < ActiveSupport::TestCase
  fixtures :posts, :drug_refs
  
  def setup
    @controller = BackendController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_fetch_no_email
    # Should return all posts, none 'trusted'
    
    result = invoke(
      :fetch,
      "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
      ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
      nil, true)

    assert_equal result.length, 8
    result.each do |r|
      assert_equal r.trusted, false
    end
     
  end
  
  def test_fetch_faulty_email
    # Same as above
    
    result = invoke(
      :fetch,
      "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
      ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
      "bob@msn.com", true)

    assert_equal result.length, 8
    result.each do |r|
      assert_equal r.trusted, false
    end
  end
  
  def test_fetch_with_debs_email_and_inclusive
    # Should return all posts, with alex, and jesus (and guest's commented) posts marked as 'trusted'
    
    result = invoke(
      :fetch,
      "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
      ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
      "dont_mugyourself@hotmail.com", true)

    assert_equal result.length, 8
    result.each do |r|
      if r.author == 'Guest' and r.id == posts(:price_one).id
        assert !r.trusted
      else
        assert r.trusted
      end
    end
    
  end
  
  def test_fetch_with_debs_email_not_inclusive
    # Should only return trusted posts (i.e. not that one un-commented Guest post)
    
    result = invoke(
      :fetch,
      "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
      ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
      "dont_mugyourself@hotmail.com", false)

    assert_equal result.length, 7
    result.each do |r|
      assert r.id != posts(:price_one).id
    end
    
  end
  
  def test_fetch_with_guest_inclusive
  # Should return all posts, and only Guest and Jesus's posts should be marked 'trusted'
  
    friends = [4, 7]
  
    result = invoke(
        :fetch,
        "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
        ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
        "this_is_fake@guest.com", true)
      
    assert_equal result.length, 8
    result.each do |r|
      if friends.include?(r.created_by)
        assert r.trusted
      else 
        assert !r.trusted
      end
    end
  
  end
  
  def test_fetch_with_guest_uninclusive
  # Should only return Guest and Jesus's posts
  
    friends = [4, 7]
  
    result = invoke(
        :fetch,
        "interactions_byATC, warnings_byATC, bulletins_byATC, prices_byATC",
        ["J05AF06", "J01CA04", "R05DA04", "R05FA02", "M04AA01", "S01AA17", "M01AB05", "C07AB02", "N06BC01"],
        "this_is_fake@guest.com", false)
    
    assert_equal result.length, 5
      
    result.each do |r|
      print r.name
      assert friends.include?(r.created_by)
    end
  
  end
  
end
