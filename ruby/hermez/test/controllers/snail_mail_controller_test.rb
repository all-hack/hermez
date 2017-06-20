require 'test_helper'

class SnailMailControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get snail_mail_index_url
    assert_response :success
  end

end
