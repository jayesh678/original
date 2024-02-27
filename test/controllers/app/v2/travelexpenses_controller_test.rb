require "test_helper"

class App::V2::TravelexpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get app_v2_travelexpenses_index_url
    assert_response :success
  end
end
