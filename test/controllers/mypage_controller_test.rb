require 'test_helper'

class MypageControllerTest < ActionController::TestCase
  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get profile_complete" do
    get :profile_complete
    assert_response :success
  end

end
