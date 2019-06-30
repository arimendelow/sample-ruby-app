require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    # This puts the value of 'root_path' etc in place of the '?'
    assert_select "a[href=?]", root_path, count: 3 # count: 3 for the logo, footer, and nav bar
    assert_select "a[href=?]", help_path, count: 2 # count: 2 for the nav bar and footer
    assert_select "a[href=?]", contact_path, count: 2 # count: 2 for the nav bar and footer
    assert_select "a[href=?]", about_path, count: 2 # count: 2 for the nav bar and footer
    assert_select "a[href=?]", signup_path
  end
end
