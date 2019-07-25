require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ari)
    @other_user = users(:potato)
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

  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other_user.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      # xhr stands for XmlHttpRequest
      # setting the xhr option to true issues an Ajax request in the test,
      # which causes the respond_to block to execute the proper JavaScript method
      post relationships_path, xhr: true, params: { followed_id: @other_user.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other_user)
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
    assert_difference '@user.following.count', -1 do
      # xhr stands for XmlHttpRequest
      # setting the xhr option to true issues an Ajax request in the test,
      # which causes the respond_to block to execute the proper JavaScript method
      delete relationship_path(relationship), xhr: true
    end
  end
end
