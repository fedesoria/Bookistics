require 'test_helper'

class BookControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

end
