require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ari)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    # If @user.following.empty? were true, not a single assert_select would execute in the loop,
    # leading the tests to pass and thereby give us a false sense of security.
    # Therefore, we do this assertion to stop the tests if it's true.
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    # If @user.following.empty? were true, not a single assert_select would execute in the loop,
    # leading the tests to pass and thereby give us a false sense of security.
    # Therefore, we do this assertion to stop the tests if it's true.
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
