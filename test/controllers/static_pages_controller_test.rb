require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # Let's test the Home page by issuing a GET request to the Static Pages 'home' URL
  # and then making sure we recieve a 'success' status code in response
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Ruby on Rails Sample Application"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Sample Application"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails Sample Application"
  end

end
