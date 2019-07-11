require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:ari)
    @micropost = @user.microposts.new(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # Verify that the first micropost in the database is the same as a fixture micropost that we've called 'most_recent'
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
