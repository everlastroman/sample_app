require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:roman)
    @micropost = @user.microposts.build(content: "Lorem ipsum dolor")
  end

  test "shoud be valid " do
    assert @micropost.valid?
  end

  test "shoud be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "micropost shoud be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "micropost shoud be most at 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order shoud be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end

end
