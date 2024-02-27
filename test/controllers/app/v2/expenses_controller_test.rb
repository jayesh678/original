require "test_helper"

class App::V2::ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get app_v2_expenses_index_url
    assert_response :success
  end
end
